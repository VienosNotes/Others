(* 
 * file "am.ml"
 *  下記のテキスト p.44 に載っている ASEC machine のインタープリタの実装 
 *  Dowek & Levy, "Introduction to the Theory of Programming Languages"
 *  Undergraduate Topics in Computer Science, Springer, 2011.
 *)

(* 
 * ASEC machine というのは、machine (計算機のCPU) の抽象的なモデルの1
 * つで、Accumulator, Stack, Environment, Code の4つの要素を組にして
 * 状態遷移を行なう機械である。
 *
 * Accumulator ... CPU の register に相当し、現在操作可能な値1つを置ける(1つしかない)
 * Stack ......... 実行時に使うstackである。これは、関数呼び出しの時に、
 *                 現在の環境をセーブしておき、関数呼び出しが終わった
 *                 あとに復活させる、というの目的のために使う。また、
 *                 計算の途中結果は、Accumulator に積めるわけでは
 *                 ないので、Stack に積んでおいて後で使う。
 * Enviroment .... 現在の実行において使うenvironmentである。これは、
 *                 stack だけを使う機械における「スタックトップにある(現在有効な)
 *                 スタックフレーム」に相当する。現在有効なスタックフ
 *                 レームは頻繁に参照するので、ASEC machine では、スタックとは別に、環
 *                 境として置いている。
 * Code .......... 実行すべき命令列  
 *
 *)

type
  (* ASEC machine における「コード」、つまり、命令の列を表す型 *)
  code = instr list 
and
  (* ASEC machine における「命令」を表す型 *)
  instr =    
  | I_Ldi of int            (* I_Ldi(n) は、整数nを Accumulator に置く (loadする) *)
  | I_Ldb of bool           (* I_Ldb(b) は、真理値bを Accumulator に置く (loadする) *)
  | I_Push                  (* Accumulatorにある値をスタックに積む *)
  | I_Extend                (* Accumulatorにある値を環境に積む (環境を拡張する) *)
  | I_Search of int         (* I_Search(i) は、環境の i 番目の値を取ってきて Accumulatorに置く *)
  | I_Pushenv               (* 現在の環境を、スタックに積む *)
  | I_Popenv                (* スタックのトップにある環境を、現在の環境とする *)
  | I_Mkclos of code        (* I_Mkclos(c) は、関数本体のコードが c で
			     * ある関数クロージャを生成し、Accumulatorに置く。
			     * なお、関数の引数は、変数名を除去しているので、
			     * このクロージャに含まれない。関数本体で
			     * は「環境の中の0番目の変数として指定される。
			     * ここでは、すべての関数を再帰関数として処理している。
			     *)
  | I_Apply                 (* Accumulator の値が関数クロージャである
			     * とき、その関数を、スタックトップにある
			     * 値に適用した計算を行なう。
			     *)
  | I_Test of code * code   (* I_Test(c1,c2)は、Accumulatorにある値が
			     * true ならば、コードc1 を実行し、false
			     * ならばコード c2 を実行する。
			     *)
  | I_Add                   (* Accumulatorにある値にスタックトップの値
			     * を加えて結果をAccumulator にいれる
			     *)
  | I_Sub                   (* Accumulatorにある値にスタックトップの値
                               を引いて結果をAccumulatorにいれる *)
  | I_Mult                  (* Accumulatorにある値にスタックトップの値
                               を掛けて結果をAccumulatorにいれる *)
  | I_Div                   (* Accumulatorにある値にスタックトップの値
                               で割って結果をAccumulatorにいれる *)
  | I_Greater               (* Accumulatorにある値がスタックトップの値
                               より大きいかどうかを比較して、結果をAccumulatorにいれる *)
  | I_Eq                    (* Accumulatorにある値とスタックトップの値
			     * が同じ整数であるかどうかをテストして、結
			     * 果をAccumulator にいれる
			     *)
  | I_Noteq                  (* Accumulatorにある値とスタックトップの値
			     * が違う整数であるかどうかをテストして、結
			     * 果をAccumulator にいれる
			     *)


(* ASEC machine における「値」を表す型 *)
type am_value =  
  | AM_IntVal  of int         
  | AM_BoolVal of bool       
  | AM_Closure of code * am_env  (* 関数クロージャ、ただし変数名は消去 *)
  | AM_Env of am_env  (* 後で述べる理由により、「環境(スタックフレーム
		       * 1つ分)」を、1つの値にして、まるごとスタックに
		       * 積む必要があるので、ここでは 環境に AM_Env と
		       * いうタグをつけると値になるようにしている。
                       *)
and
  (* ASEC machine における「スタック」を表す型 *)
  am_stack = am_value list (* スタックは、値のリスト(列)である。
                            * これは、環境(現在有効なスタックフレーム)
			    * にAM_Envというタグをつけたものか、
			    * あるいは、単純な(整数リテラルなどの)
			    * 値を積んだものである。前者は、関数呼び出
			    * しの際に現在のスタックフレームを保存しておくも
			    * のであり、後者は、1+(2+3) の計算などの際
			    * に、途中結果を保存しておくものである。
                            *)
and
  (* ASEC machine における「環境」を表す型 *)
  am_env = am_value list (* 環境は、1つのスタックフレームに相当する。
                          * インタープリタでの環境は、[(x,100); (y,"abc"); (z,true)]
                          * といったリストであったが、ASEC machineでは、変数名
			  * を使わないので、[100; "abc"; true]といった
			  * ものが環境となる。そして、変数y が 1番目の
			  * 要素といったことを覚えおいて、(変数名では
			  * なく)、環境中のインデックス(何番目の要素か)で参照する。
                          *)

(* ASEC machine の状態遷移(計算)*)
let rec trans (a:am_value) (s:am_stack) (e:am_env) (c:code) : am_value =
  let binop (a:am_value) (s:am_stack) (f:instr) : (am_value * am_stack) =
    begin
      match (f,      a,            s               ) with
	|   (I_Add,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_IntVal (n+m), s1)
	|   (I_Sub,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_IntVal (n-m), s1)
	|   (I_Mult,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_IntVal (n*m), s1)
	|   (I_Div,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_IntVal (n/m), s1)
	|   (I_Greater,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_BoolVal (n>m), s1)
	|   (I_Eq ,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_BoolVal(n=m), s1)
	|   (I_Noteq ,  AM_IntVal(n), AM_IntVal(m)::s1) -> (AM_BoolVal(n!=m), s1)
	| _ -> failwith "unexpected type of argument(s) for binary operation"
    end
  in 
  match (a,s,e,c) with 
    | (_,[],[],[]) -> a   (* コードが空の時、Accumulatorの値が最終結果 *)
    | (_,_,_,[]) -> failwith "non-empty stack or environment"  
	(* 計算が終わった時、スタックと環境は空であるべき。 *)
    | (_,_,_,I_Mkclos(c2)::c1) -> trans (AM_Closure(c2,e)) s e c1
    | (_,_,_,I_Push      ::c1) -> trans a (a::s) e c1
    | (_,_,_,I_Extend    ::c1) -> trans a s (a::e) c1
    | (_,_,_,I_Search(n) ::c1) -> trans (List.nth e n) s e c1
    | (_,_,_,I_Pushenv   ::c1) -> trans a (AM_Env(e)::s) e c1
    | (_,AM_Env(e1)::s1,_,I_Popenv::c1) -> trans a s1 e1 c1
    | (_,_::_          ,_,I_Popenv::c1) -> failwith "non-environment on the stack top"
    | (_,_             ,_,I_Popenv::c1) -> failwith "empty stack for Pop"
    | (AM_Closure(c2,e1),v::s1,_,I_Apply::c1) -> trans a s1 (v::a::e1) (c2@c1)
    | (_                ,_::_ ,_,I_Apply::c1) -> failwith "closure expected in accumulator for Apply"
    | (_                ,_    ,_,I_Apply::c1) -> failwith "empty stack for Apply"
    | (_,_,_,I_Ldi(n)::c1) -> trans (AM_IntVal(n))  s e c1
    | (_,_,_,I_Ldb(b)::c1) -> trans (AM_BoolVal(b)) s e c1
    | (AM_BoolVal(true), _,_,I_Test(c2,_ )::c1) -> trans a s e (c2 @ c1)
    | (AM_BoolVal(false),_,_,I_Test(_ ,c3)::c1) -> trans a s e (c3 @ c1)
    | (_,                _,_,I_Test(_ ,_ )::_ ) -> failwith "boolean expected for if-test"
    | (_,_,_,i       ::c1) 
	when List.mem i [I_Add; I_Sub; I_Mult; I_Div; I_Greater; I_Eq; I_Noteq] 
	-> 
	let (v,s1) = binop a s i
	in trans v s1 e c1
    | _ -> failwith "unknown instruction" 

(* evaluation of ASEC machine *)
let am_eval (c:code) : am_value =
  trans (AM_IntVal(0)) [] [] c     (* Accumulatorの初期値は 0
				    * スタックの初期値は []
				    * 環境の初期値は []
				    * という状態で、コード c の計算を行なう。
				    *)
				      

(* テストコード *)

(* 
 * 1 + 2
 *)
let code0 = [I_Ldi 2; I_Push; I_Ldi 1; I_Add];;
let _ = am_eval code0;;

(* 
 * let x=true in if x then 1 else 2
 *)
let code1 =
 [I_Pushenv; I_Ldb true; I_Extend; I_Search 0; 
  I_Test ([I_Ldi 1], [I_Ldi 2]); I_Popenv];;

let _ = am_eval code1 ;;

(* 
 * let rec f x = if x = 0 then 0 else x + (f (x + (-1))) in f 3
 *)
let code2 = 
 [I_Pushenv;
 I_Mkclos
  [I_Ldi 0; I_Push; I_Search 0; I_Eq;
   I_Test ([I_Ldi 0],
    [I_Pushenv; I_Ldi (-1); I_Push; I_Search 0; I_Add; I_Push; I_Search 1;
     I_Apply; I_Popenv; I_Push; I_Search 0; I_Add])];
 I_Extend; I_Pushenv; I_Ldi 3; I_Push; I_Search 0; I_Apply; I_Popenv;
 I_Popenv];;

let _ = am_eval code2 ;;

let code3 =
  [I_Ldi 4; I_Push; I_Ldi 10; I_Sub];;

let _ = am_eval code3;;

let code4 =
  [I_Ldi 2; I_Push; I_Ldi 3; I_Mult];;

let _ = am_eval code4;;

let code5 =
  [I_Ldi 4; I_Push; I_Ldi 8; I_Div];;

let _ = am_eval code5;;

let code6 =
  [I_Ldi 4; I_Push; I_Ldi 3; I_Greater];;

let _ = am_eval code6;;

let code7 =
  [I_Ldi 4; I_Push; I_Ldi 1; I_Noteq];;

let _ = am_eval code7;;
