require './model/lucha.rb'

ESCENARIO = ARGV[0]
PRIMER_LUCHADOR = ARGV[1]
SEGUNDO_LUCHADOR = ARGV[3]
P_ARMA = ARGV[2]
S_ARMA = ARGV[4]

lucha = Lucha.new
resultado = lucha.obtener_ganador(ESCENARIO, PRIMER_LUCHADOR, P_ARMA, SEGUNDO_LUCHADOR, S_ARMA)

# Decidi poner la condicion de esta forma asi no hacia la linea de codigo tan larga
if resultado.length < 10
  puts 'Resultado: ' + resultado
else
  puts 'error: ' + resultado
end
