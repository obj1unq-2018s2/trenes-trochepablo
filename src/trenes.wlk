class Formacion{
	var property locomotoras = []
	var property vagones = []
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
		
	method pesoEmpujeFaltate() =  vagones.sum{ x => x.pesoMaximo()} - locomotoras.sum{ x => x.pesoMaximoArrastrar() } 
}

class Locomotora{
	var property peso
	var property pesoMaximoArrastrar
	var property velocidadMax 
	
}

class VagonPasajero{
	var largo = 0
	var ancho = 0
	var property cargaMaxima = 0
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
		if (not formacion.puedeMoverse() && self.hayLocoArrastreUtil(formacion.pesoEmpujeFaltate())) {
			formacion.locomotoras().add(locomotorasSueltas.find{ l => l.pesoMaximoArrastrar() >= formacion.pesoEmpujeFaltate() })
		}
	}
	method hayLocoArrastreUtil(arrastreFaltante){
		return locomotorasSueltas.any{l => l.pesoMaximoArrastrar() >= arrastreFaltante }
	}
}