class Persona {
	var edad
	var altura
	var hijosACargo
	
	method altura() = altura
	
	method esInfante() = edad < 12
	
	method esPadre() = hijosACargo.any({hijo => hijo.esInfante()})
}

class Juego{
	var categoria
		
	method puedeIngresar(persona) = true
	
	method categoria() = categoria
}

class JuegoVertigo inherits Juego{
	var alturaMinima
	
	override method puedeIngresar(persona) = persona.altura() > alturaMinima
}

class JuegoInfantil inherits Juego{
	override method puedeIngresar(persona) = persona.esInfante() || persona.esPadre()
}

class Entrada{
	var atracion
	var noSeUso = true
	
	method permiteIngresar(atracionDeseada){
		if(atracionDeseada == atracion && noSeUso){
			noSeUso = false
			return true
		} else return false
	}
}

class Pase{
	method permiteIngresar(atracionDeseada) = true
}

class PasePromo inherits Pase{
	override method permiteIngresar(atracionDeseada) =
		atracionDeseada.categoria() == "infantil" || atracionDeseada.categoria() == "show"
}

class PaseOro inherits Pase{
	var atraccionesPermitidas
	
	override method permiteIngresar(atracionDeseada) =
		atraccionesPermitidas.any({atracion => atracion == atracionDeseada})
}

/* objetos para test */
object infante inherits Persona(edad = 11, altura = 102, hijosACargo = []){}
object padre inherits Persona(edad = 30, altura = 182, hijosACargo = [infante]){}
object otro inherits Persona(edad = 26, altura = 178, hijosACargo = []){}

object montaniaRusa inherits JuegoVertigo(categoria="vertigo", alturaMinima=110){}
object tazasGiratorias inherits JuegoInfantil(categoria="infantil"){}
object recital inherits Juego(categoria="show"){}

object entradaRecital inherits Entrada(atracion = recital){}
object entradaMontaniaRusa inherits Entrada(atracion = montaniaRusa){}
object paseFull inherits Pase{}
object pasePromo inherits PasePromo{}
object paseOro inherits PaseOro(atraccionesPermitidas= [tazasGiratorias, recital]){}