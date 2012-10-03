let rec gcd (x, y) =   
  if x <= 0 || y <= 0 then gcd (abs x, abs y)
  else if x = y then x
  else if x > y then gcd(x-y, y)
  else gcd(x, y-x);;

gcd(10, -25);;
gcd(1287192390, 1293749908);;
