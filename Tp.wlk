class Persona {
	var edad
	var altura
	var hijosACargo
	var adrenalina
	var entradas
	var pase
	
	method altura() = altura
	
	method esInfante() = edad < 12
	
	method esPadre() = hijosACargo.any({hijo => hijo.esInfante()})
	
	/* metodo encargado de calcular solo el gasto personal (no tiene en cuenta si tiene hijos)
	 * en caso de ser infante no tiene gasto personal*/
	method costoUnitario() {
		if(!self.esInfante()) return pase.costo() + entradas.sum({entrada => entrada.costo()})
		else return 0
	}
	
	/* primero se calcula el gasto personal, despues si es padre, se suma el gasto de sus hijos */
	method gasto(){
		var costo = self.costoUnitario()
		if(self.esPadre()) costo += hijosACargo.sum({hijo => hijo.costoUnitario()})
		return costo
	}
}

class AtraccionGeneral{
	const categoria
	var costo
		
	method puedeIngresar(persona) = true
	
	method categoria() = categoria
	
	method costo() = costo
}

class AtraccionVertigo inherits AtraccionGeneral{
	const alturaMinima
	
	override method puedeIngresar(persona) = persona.altura() > alturaMinima
}

class AtraccionInfantil inherits AtraccionGeneral{
	
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
	
	method costo() = atracion.costo()
}

class Pase{	
	method permiteIngresar(atracionDeseada) = true
}

class PaseFull inherits Pase{
	method costo() = 600
}

class PasePromo inherits Pase{
	method costo() = 200
	
	override method permiteIngresar(atracionDeseada) =
		atracionDeseada.categoria() == "infantil" || atracionDeseada.categoria() == "show"
}

class PaseOro inherits Pase{
	var atraccionesPermitidas
	
	method costo() = atraccionesPermitidas.sum({atraccion => atraccion.costo()})
	
	override method permiteIngresar(atracionDeseada) =
		atraccionesPermitidas.any({atracion => atracion == atracionDeseada})
}

/*
 * 1 - los nombres de las variables no son descriptivos
 * 2 - ingresar en PersonaTemerosa devuelve un valor cuando no deberia
 * 3 - el metodo ingresar no esta usando atracion para validar el tipo de atraccion
 * 4 - adrenalina podria estar en persona dado que es comun en ambas implementaciones
 * 5 - el metodo ingresar tambien compartes parte de la implementacion, por lo que una clase podria heredar de otra para simplificar el codigo
 */
class PersonaTemeraria inherits Persona {
    method ingresar(atraccion) {
        adrenalina += 10
    }
}
class PersonaTemerosa inherits Persona {
    var miedo
    method ingresar(atraccion) {
        adrenalina += 10
        miedo += 20
    }
}

/* objetos para test */
const montaniaRusa = new AtraccionVertigo(categoria="Vertigo",costo=30,alturaMinima=130)
const desorbitados = new AtraccionVertigo(categoria="Vertigo",costo=25,alturaMinima=100)
const tazasGiratorias = new AtraccionInfantil(categoria="Intantil",costo=5)
const recital = new AtraccionGeneral(categoria="show",costo=10)

const entradaRecital = new Entrada(atracion = recital)
const entradaMontaniaRusa = new Entrada(atracion = montaniaRusa)
const paseFull = new PaseFull()
const pasePromo = new PasePromo()
const paseOro = new PaseOro(atraccionesPermitidas= [tazasGiratorias, recital])

const infante = new PersonaTemerosa(edad = 11, altura = 102, adrenalina = 10, miedo= 0, hijosACargo=[], entradas=[], pase=null)
const otro = new PersonaTemeraria(edad = 25, altura = 172, adrenalina = 10, hijosACargo=[], entradas=[entradaRecital], pase=paseFull)
const padre = new PersonaTemeraria(edad = 35, altura = 182, adrenalina = 10, hijosACargo=[infante, otro], entradas=[], pase=pasePromo)