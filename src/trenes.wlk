class Formacion{
	var locomotoras
	var vagones
	method vagonesLivianos() = vagones.count{ x => x.pesoMaximo() < 2500 }
	method velocidadMaxima() = locomotoras.min{ x => x.velocidadMax() }.velocidadMax()
	method esEficiente() = locomotoras.all{ x => x.pesoMaximoArrastrar() >= x.peso() * 5 }
	method puedeMoverse() {
		return locomotoras.sum{ x => x.pesoMaximoArrastrar() } >= vagones.sum{ x => x.pesoMaximo() }
	}
	method cantidadKilosEmpuje(){
		var cantidad = 0
		if (self.puedeMoverse()) {
			cantidad = 0
		}
		else{
			cantidad = vagones.sum{ x => x.pesoMaximo() } - locomotoras.sum{ x => x.pesoMaximoArrastrar() }
		}
		return cantidad
	}
	method maxVagonPeso() = vagones.max{ x => x.pesoMaximo() }
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
	var locomotorasSueltas
	var formacionesArmadas
	method vagonesMasPesados() = formacionesArmadas.map{ x => x.maxVagonPeso() }.asSet()
}