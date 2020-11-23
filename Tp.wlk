class Persona {
	var edad
	var altura
	var hijosACargo
	var pase
	var entradas
	
	method altura() = altura
	
	method esInfante() = edad < 12
	
	method esPadre() = hijosACargo.any({hijo => hijo.esInfante()})
	
	method calcularCosto(){
		var costo = 0
		if(!self.esInfante()){
			costo += pase.costo()
			entradas.forEach({entrada => costo += entrada.costo()})
			costo += costo / 2
		}
		if(self.esPadre()){
			hijosACargo.forEach({hijo => costo += hijo.calcularCosto()})
		}
		return costo
	}
}

class Atraccion{
	const categoria
	var costo
		
	method puedeIngresar(persona) = true
	
	method categoria() = categoria
	
	method costo() = costo
}

class AtraccionVertigo inherits Atraccion{
	const alturaMinima
	
	override method puedeIngresar(persona) = persona.altura() > alturaMinima
}

class AtraccionInfantil inherits Atraccion{	
	override method puedeIngresar(persona) = persona.esInfante() || persona.esPadre()
}

class Entrada{
	var atracion
	var noSeUso = true
	
	method costo() = atracion.costo()
	
	method permiteIngresar(atracionDeseada){
		if(atracionDeseada == atracion && noSeUso){
			noSeUso = false
			return true
		} else return false
	}
}

class PaseFull{
	method permiteIngresar(atracionDeseada) = true
	
	method precio() = 600
}

class PasePromo inherits PaseFull{
	override method permiteIngresar(atracionDeseada) =
		atracionDeseada.categoria() == "infantil" || atracionDeseada.categoria() == "show"
		
	override method precio() = 200
}

class PaseOro inherits PaseFull{
	var atraccionesPermitidas
	
	override method permiteIngresar(atracionDeseada) =
		atraccionesPermitidas.any({atracion => atracion == atracionDeseada})
		
	override method precio(){
		var acumulado = 0
		atraccionesPermitidas.forEach({atracion => acumulado += atracion.costo()})
		return acumulado / 2
	} 
}

/*
 * 1 - los nombres de las variables no son descriptivos
 * 2 - ingresar en PersonaTemerosa devuelve un valor cuando no deberia
 * 3 - el metodo ingresar no esta usando atracion para validar el tipo de atraccion
 * 4 - adrenalina podria estar en persona dado que es comun en ambas implementaciones
 * 5 - el metodo ingresar tambien compartes parte de la implementacion, por lo que una clase podria heredar de otra para simplificar el codigo
 */
class PersonaTemeraria inherits Persona {
	var adrenalina

    method ingresar(atraccion) {
        adrenalina += 10
    }
}
class PersonaTemerosa inherits PersonaTemeraria {
    var miedo
    override method ingresar(atraccion) {
        super(atraccion)
        miedo += 20
    }
}


/* objetos para test */
object infante inherits Persona(edad = 11, altura = 102, hijosACargo = []){}
object padre inherits Persona(edad = 30, altura = 182, hijosACargo = [infante, otro]){}
object otro inherits Persona(edad = 26, altura = 178, hijosACargo = []){}

object montaniaRusa inherits AtraccionVertigo(categoria="vertigo",alturaMinima=110){}
object tazasGiratorias inherits AtraccionInfantil(categoria="infantil"){}
object recital inherits Atraccion(categoria="show"){}

object entradaRecital inherits Entrada(atracion = recital){}
object entradaMontaniaRusa inherits Entrada(atracion = montaniaRusa){}
object paseFull inherits PaseFull{}
object pasePromo inherits PasePromo{}
object paseOro inherits PaseOro(atraccionesPermitidas= [tazasGiratorias, recital]){}