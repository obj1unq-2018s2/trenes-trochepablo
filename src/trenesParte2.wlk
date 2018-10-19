class Formacion{
	var property locomotoras = []
	var property vagones = []
	var property uneCiudadesGrandes = false
	method vagonesLivianos() = vagones.count{ x => x.pesoMaximo() < 2500 }
	method velocidadMaxima() = locomotoras.min{ x => x.velocidadMax() }.velocidadMax()
	method esEficiente() = locomotoras.all{ x => x.pesoMaximoArrastrar() >= x.peso() * 5 }
	method puedeMoverse() {
		return locomotoras.sum{ x => x.pesoMaximoArrastrar() } >= vagones.sum{ x => x.pesoMaximo() }
	}
	method cantidadKilosEmpuje(){
		var cantidad = 0
		if (not self.puedeMoverse()) {
			cantidad = vagones.sum{ x => x.pesoMaximo() } - locomotoras.sum{ x => x.pesoMaximoArrastrar() }
		}
		return cantidad
	}
	method maxVagonPeso() = vagones.max{ x => x.pesoMaximo() }

	method esCompleja() = 
		locomotoras.size() + vagones.size() > 20 ||
		locomotoras.sum{ x => x.peso() } + vagones.sum({x => x.pesoMaximo()}) > 10000
		
	method formacionBienArmada(){
		return self.puedeMoverse()
	}
	
	method tieneBanosParaPasajeros(cantPasajeros){
		return self.vagones().sum{x => x.cantidaBanos()} > cantPasajeros
	}
}

class FormacionLargaDistancia inherits Formacion {
	override method formacionBienArmada(){
		return super() && self.tieneBanosParaPasajeros(50)
	}
	method limiteVelicidad() { if (self.uneCiudadesGrandes()){return 200} else {return 150}}
}

class FormacionCortaDistancia inherits Formacion {
	method limiteVelicidad() { if (self.velocidadMaxima() < 60){return self.velocidadMaxima()} else {return 60}}
	override method formacionBienArmada(){
		return super() && not self.esCompleja()
	}
}

class FormacionAltaVelocidad inherits FormacionLargaDistancia {
	override method formacionBienArmada(){
		return self.velocidadMaxima() > 250 && self.vagonesLivianos() == self.vagones().size() 
	}
}

class Locomotora{
	var property peso
	var property pesoMaximoArrastrar
	var property velocidadMax 
	
}

class VagonPasajero{
	var property largo = 0
	var property ancho = 0
	var property cargaMaxima = 0
	var property cantidadBanos = 0
	method cantidadPasajeros(){
		var cantidad = 0
		if (ancho <= 2.5) {
			cantidad = largo * 8
		}
		else{
			cantidad = largo * 10
		}	
		return cantidad
	} 
	method tienePasajeros() = true
	method pesoMaximo() = self.cantidadPasajeros() * 80
}
class VagonCarga{
	var largo = 0
	var ancho = 0
	var property cargaMaxima = 0
	var property cantidadBanos = 0
	method cantidadPasajeros(){
		var cantidad = 0
		if (ancho <= 2.5) {
			cantidad = largo * 8
		}
		else{
			cantidad = largo * 10
		}	
		return cantidad
	} 
	method tienePasajeros() = false
	method pesoMaximo() = cargaMaxima + 160
}

class Deposito{
	var property locomotorasSueltas = []
	var property formacionesArmadas = []
	method vagonesMasPesados() = formacionesArmadas.map{ x => x.maxVagonPeso() }.asSet()
	method conductorExperimentado() = formacionesArmadas.any{ x => x.esCompleja() }
	method agregarLocomotoraAFormacion(formacion){
		if (not formacion.puedeMoverse() && self.hayLocoArrastreUtil(formacion.cantidadKilosEmpuje())) {
			const locomotora = locomotorasSueltas.find{ l => l.pesoMaximoArrastrar() >= formacion.cantidadKilosEmpuje()}
			formacion.locomotoras().add(locomotora)
			locomotorasSueltas.remove(locomotora)
		}
	}
	method hayLocoArrastreUtil(arrastreFaltante){
		return locomotorasSueltas.any{l => l.pesoMaximoArrastrar() >= arrastreFaltante }
	}
}