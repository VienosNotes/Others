(* 
 * file "am.ml"
 *  �����Υƥ����� p.44 �˺ܤäƤ��� ASEC machine �Υ��󥿡��ץ꥿�μ��� 
 *  Dowek & Levy, "Introduction to the Theory of Programming Languages"
 *  Undergraduate Topics in Computer Science, Springer, 2011.
 *)

(* 
 * ASEC machine �Ȥ����Τϡ�machine (�׻�����CPU) �����Ū�ʥ�ǥ��1
 * �Ĥǡ�Accumulator, Stack, Environment, Code ��4�Ĥ����Ǥ��Ȥˤ���
 * �������ܤ�Ԥʤ������Ǥ��롣
 *
 * Accumulator ... CPU �� register ������������������ǽ����1�Ĥ��֤���(1�Ĥ����ʤ�)
 * Stack ......... �¹Ի��˻Ȥ�stack�Ǥ��롣����ϡ��ؿ��ƤӽФ��λ��ˡ�
 *                 ���ߤδĶ��򥻡��֤��Ƥ������ؿ��ƤӽФ�������ä�
 *                 ���Ȥ����褵���롢�Ȥ�������Ū�Τ���˻Ȥ����ޤ���
 *                 �׻��������̤ϡ�Accumulator ���Ѥ��櫓�Ǥ�
 *                 �ʤ��Τǡ�Stack ���Ѥ�Ǥ����Ƹ�ǻȤ���
 * Enviroment .... ���ߤμ¹Ԥˤ����ƻȤ�environment�Ǥ��롣����ϡ�
 *                 stack ������Ȥ������ˤ�����֥����å��ȥåפˤ���(����ͭ����)
 *                 �����å��ե졼��פ��������롣����ͭ���ʥ����å���
 *                 �졼������ˤ˻��Ȥ���Τǡ�ASEC machine �Ǥϡ������å��Ȥ��̤ˡ���
 *                 ���Ȥ����֤��Ƥ��롣
 * Code .......... �¹Ԥ��٤�̿����  
 *
 *)

type
  (* ASEC machine �ˤ�����֥����ɡס��Ĥޤꡢ̿������ɽ���� *)
  code = instr list 
and
  (* ASEC machine �ˤ������̿��פ�ɽ���� *)
  instr =    
  | I_Ldi of int            (* I_Ldi(n) �ϡ�����n�� Accumulator ���֤� (load����) *)
  | I_Ldb of bool           (* I_Ldb(b) �ϡ�������b�� Accumulator ���֤� (load����) *)
  | I_Push                  (* Accumulator�ˤ����ͤ򥹥��å����Ѥ� *)
  | I_Extend                (* Accumulator�ˤ����ͤ�Ķ����Ѥ� (�Ķ����ĥ����) *)
  | I_Search of int         (* I_Search(i) �ϡ��Ķ��� i ���ܤ��ͤ��äƤ��� Accumulator���֤� *)
  | I_Pushenv               (* ���ߤδĶ��򡢥����å����Ѥ� *)
  | I_Popenv                (* �����å��Υȥåפˤ���Ķ��򡢸��ߤδĶ��Ȥ��� *)
  | I_Mkclos of code        (* I_Mkclos(c) �ϡ��ؿ����ΤΥ����ɤ� c ��
			     * ����ؿ������������������Accumulator���֤���
			     * �ʤ����ؿ��ΰ����ϡ��ѿ�̾�����Ƥ���Τǡ�
			     * ���Υ�������˴ޤޤ�ʤ����ؿ����Τ�
			     * �ϡִĶ������0���ܤ��ѿ��Ȥ��ƻ��ꤵ��롣
			     * �����Ǥϡ����٤Ƥδؿ���Ƶ��ؿ��Ȥ��ƽ������Ƥ��롣
			     *)
  | I_Apply                 (* Accumulator ���ͤ��ؿ���������Ǥ���
			     * �Ȥ������δؿ��򡢥����å��ȥåפˤ���
			     * �ͤ�Ŭ�Ѥ����׻���Ԥʤ���
			     *)
  | I_Test of code * code   (* I_Test(c1,c2)�ϡ�Accumulator�ˤ����ͤ�
			     * true �ʤ�С�������c1 ��¹Ԥ���false
			     * �ʤ�Х����� c2 ��¹Ԥ��롣
			     *)
  | I_Add                   (* Accumulator�ˤ����ͤ˥����å��ȥåפ���
			     * ��ä��Ʒ�̤�Accumulator �ˤ����
			     *)
  | I_Sub                   (* Accumulator�ˤ����ͤ˥����å��ȥåפ���
                               ������Ʒ�̤�Accumulator�ˤ���� *)
  | I_Mult                  (* Accumulator�ˤ����ͤ˥����å��ȥåפ���
                               ��ݤ��Ʒ�̤�Accumulator�ˤ���� *)
  | I_Div                   (* Accumulator�ˤ����ͤ˥����å��ȥåפ���
                               �ǳ�äƷ�̤�Accumulator�ˤ���� *)
  | I_Greater               (* Accumulator�ˤ����ͤ������å��ȥåפ���
                               ����礭�����ɤ�������Ӥ��ơ���̤�Accumulator�ˤ���� *)
  | I_Eq                    (* Accumulator�ˤ����ͤȥ����å��ȥåפ���
			     * ��Ʊ�������Ǥ��뤫�ɤ�����ƥ��Ȥ��ơ���
			     * �̤�Accumulator �ˤ����
			     *)
  | I_Noteq                  (* Accumulator�ˤ����ͤȥ����å��ȥåפ���
			     * ���㤦�����Ǥ��뤫�ɤ�����ƥ��Ȥ��ơ���
			     * �̤�Accumulator �ˤ����
			     *)


(* ASEC machine �ˤ�������͡פ�ɽ���� *)
type am_value =  
  | AM_IntVal  of int         
  | AM_BoolVal of bool       
  | AM_Closure of code * am_env  (* �ؿ��������㡢�������ѿ�̾�Ͼõ� *)
  | AM_Env of am_env  (* ��ǽҤ٤���ͳ�ˤ�ꡢ�ִĶ�(�����å��ե졼��
		       * 1��ʬ)�פ�1�Ĥ��ͤˤ��ơ��ޤ뤴�ȥ����å���
		       * �Ѥ�ɬ�פ�����Τǡ������Ǥ� �Ķ��� AM_Env ��
		       * ����������Ĥ�����ͤˤʤ�褦�ˤ��Ƥ��롣
                       *)
and
  (* ASEC machine �ˤ�����֥����å��פ�ɽ���� *)
  am_stack = am_value list (* �����å��ϡ��ͤΥꥹ��(��)�Ǥ��롣
                            * ����ϡ��Ķ�(����ͭ���ʥ����å��ե졼��)
			    * ��AM_Env�Ȥ���������Ĥ�����Τ���
			    * ���뤤�ϡ�ñ���(������ƥ��ʤɤ�)
			    * �ͤ��Ѥ����ΤǤ��롣���Ԥϡ��ؿ��Ƥӽ�
			    * ���κݤ˸��ߤΥ����å��ե졼�����¸���Ƥ�����
			    * �ΤǤ��ꡢ��Ԥϡ�1+(2+3) �η׻��ʤɤκ�
			    * �ˡ������̤���¸���Ƥ�����ΤǤ��롣
                            *)
and
  (* ASEC machine �ˤ�����ִĶ��פ�ɽ���� *)
  am_env = am_value list (* �Ķ��ϡ�1�ĤΥ����å��ե졼����������롣
                          * ���󥿡��ץ꥿�ǤδĶ��ϡ�[(x,100); (y,"abc"); (z,true)]
                          * �Ȥ��ä��ꥹ�ȤǤ��ä�����ASEC machine�Ǥϡ��ѿ�̾
			  * ��Ȥ�ʤ��Τǡ�[100; "abc"; true]�Ȥ��ä�
			  * ��Τ��Ķ��Ȥʤ롣�����ơ��ѿ�y �� 1���ܤ�
			  * ���ǤȤ��ä����Ȥ�Ф������ơ�(�ѿ�̾�Ǥ�
			  * �ʤ�)���Ķ���Υ���ǥå���(�����ܤ����Ǥ�)�ǻ��Ȥ��롣
                          *)

(* ASEC machine �ξ�������(�׻�)*)
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
    | (_,[],[],[]) -> a   (* �����ɤ����λ���Accumulator���ͤ��ǽ���� *)
    | (_,_,_,[]) -> failwith "non-empty stack or environment"  
	(* �׻�������ä����������å��ȴĶ��϶��Ǥ���٤��� *)
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
  trans (AM_IntVal(0)) [] [] c     (* Accumulator�ν���ͤ� 0
				    * �����å��ν���ͤ� []
				    * �Ķ��ν���ͤ� []
				    * �Ȥ������֤ǡ������� c �η׻���Ԥʤ���
				    *)
				      

(* �ƥ��ȥ����� *)

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
