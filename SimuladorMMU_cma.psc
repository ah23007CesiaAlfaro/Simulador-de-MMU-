// ============================================================
// MODULO: AdministradorMemoria
// Simulador de Gestion de Memoria (MMU)
// ============================================================

// ------------------------------------------------------------
// SubProceso: InicializarRAM
// Inicializa los 4 marcos fisicos como libres
// ------------------------------------------------------------
SubProceso InicializarRAM(MarcoOcupado Por Referencia, MarcoPagina Por Referencia)
	Para i <- 0 Hasta 3
		MarcoOcupado[i] <- 0
		MarcoPagina[i]  <- -1
	FinPara
FinSubProceso

// ------------------------------------------------------------
// SubProceso: MostrarMapaBits
// Imprime 0=libre o 1=ocupado por cada marco fisico
// ------------------------------------------------------------
SubProceso MostrarMapaBits(MarcoOcupado Por Referencia, MarcoPagina Por Referencia)
	Escribir "Mapa de bits de la RAM (0=libre, 1=ocupado):"
	Escribir "Marco | Estado | Pagina"
	Escribir "------|--------|-------"
	Para i <- 0 Hasta 3
		Si MarcoPagina[i] <> -1 Entonces
			Escribir "  M", i, "  |   ", MarcoOcupado[i], "    |  P", MarcoPagina[i]
		Sino
			Escribir "  M", i, "  |   ", MarcoOcupado[i], "    |  --"
		FinSi
	FinPara
FinSubProceso

// ------------------------------------------------------------
// Funcion: TraducirDireccion
// MMU: convierte pagina logica + offset a direccion fisica
// Retorna -1 si hay fallo de pagina
// ------------------------------------------------------------
Funcion dirFisica <- TraducirDireccion(Presente Por Referencia, MarcoDePagina Por Referencia, paginaLogica, offset)
	TAM_MARCO <- 4096
	Si Presente[paginaLogica] = 0 Entonces
		dirFisica <- -1
	Sino
		marco     <- MarcoDePagina[paginaLogica]
		dirFisica <- (marco * TAM_MARCO) + offset
	FinSi
FinFuncion

// ------------------------------------------------------------
// SubProceso: InicializarMarcosUsuario
// Deja los 3 marcos del usuario vacios
// ------------------------------------------------------------
SubProceso InicializarMarcosUsuario(Marcos_U Por Referencia, cantCargadas Por Referencia)
	Para i <- 0 Hasta 2
		Marcos_U[i] <- -1
	FinPara
	cantCargadas <- 0
FinSubProceso

// ------------------------------------------------------------
// Funcion: BuscarPaginaEnMarcos
// Retorna Verdadero si la pagina ya esta en algun marco
// ------------------------------------------------------------
Funcion encontrado <- BuscarPaginaEnMarcos(Marcos_U Por Referencia, pag)
	encontrado <- Falso
	Para i <- 0 Hasta 2
		Si Marcos_U[i] = pag Entonces
			encontrado <- Verdadero
		FinSi
	FinPara
FinFuncion

// ------------------------------------------------------------
// Funcion: SimularFIFO
// Ejecuta el algoritmo FIFO y retorna el total de fallos
// ------------------------------------------------------------
Funcion fallos <- SimularFIFO(Referencias Por Referencia)
	Dimension Marcos_F[3]
	cantCargadas <- 0
	InicializarMarcosUsuario(Marcos_F, cantCargadas)
	fallos      <- 0
	punteroFIFO <- 0
	
	Escribir ""
	Escribir "=== Simulacion FIFO ==="
	Escribir "Paso | Pag | Marco0 | Marco1 | Marco2 | Fallo"
	Escribir "-----|-----|--------|--------|--------|------"
	
	Para t <- 0 Hasta 11
		pag <- Referencias[t]
		
		Si BuscarPaginaEnMarcos(Marcos_F, pag) = Falso Entonces
			fallos  <- fallos + 1
			esFallo <- "SI <-- FALLO"
			
			Si cantCargadas < 3 Entonces
				Marcos_F[cantCargadas] <- pag
				cantCargadas <- cantCargadas + 1
			Sino
				Marcos_F[punteroFIFO] <- pag
				punteroFIFO <- (punteroFIFO + 1) MOD 3
			FinSi
		Sino
			esFallo <- "no"
		FinSi
		
		Escribir t+1, " | P", pag, " |  P", Marcos_F[0], "  |  P", Marcos_F[1], "  |  P", Marcos_F[2], "  | ", esFallo
	FinPara
FinFuncion

// ------------------------------------------------------------
// Funcion: ElegirVictimaOPT
// Retorna el indice del marco cuya pagina se usa mas lejos
// ------------------------------------------------------------
Funcion victima <- ElegirVictimaOPT(Marcos_U Por Referencia, Referencias Por Referencia, tActual)
	mejorMarco <- 0
	mayorDist  <- -1
	
	Para i <- 0 Hasta 2
		pagEnMarco     <- Marcos_U[i]
		dist           <- 99999
		k              <- tActual + 1
		encontroFuturo <- Falso
		
		Mientras k <= 11 Y encontroFuturo = Falso Hacer
			Si Referencias[k] = pagEnMarco Entonces
				dist           <- k - tActual
				encontroFuturo <- Verdadero
			Sino
				k <- k + 1
			FinSi
		FinMientras
		
		Si dist > mayorDist Entonces
			mayorDist  <- dist
			mejorMarco <- i
		FinSi
	FinPara
	
	victima <- mejorMarco
FinFuncion

// ------------------------------------------------------------
// Funcion: SimularOPT
// Ejecuta el algoritmo Optimo y retorna el total de fallos
// ------------------------------------------------------------
Funcion fallos <- SimularOPT(Referencias Por Referencia)
	Dimension Marcos_O[3]
	cantCargadas <- 0
	InicializarMarcosUsuario(Marcos_O, cantCargadas)
	fallos <- 0
	
	Escribir ""
	Escribir "=== Simulacion OPT (Optimo) ==="
	Escribir "Paso | Pag | Marco0 | Marco1 | Marco2 | Fallo"
	Escribir "-----|-----|--------|--------|--------|------"
	
	Para t <- 0 Hasta 11
		pag <- Referencias[t]
		
		Si BuscarPaginaEnMarcos(Marcos_O, pag) = Falso Entonces
			fallos  <- fallos + 1
			esFallo <- "SI <-- FALLO"
			
			Si cantCargadas < 3 Entonces
				Marcos_O[cantCargadas] <- pag
				cantCargadas <- cantCargadas + 1
			Sino
				v <- ElegirVictimaOPT(Marcos_O, Referencias, t)
				Marcos_O[v] <- pag
			FinSi
		Sino
			esFallo <- "no"
		FinSi
		
		Escribir t+1, " | P", pag, " |  P", Marcos_O[0], "  |  P", Marcos_O[1], "  |  P", Marcos_O[2], "  | ", esFallo
	FinPara
FinFuncion

// ============================================================
// PROGRAMA PRINCIPAL
// ============================================================
Proceso Principal
	
	// --- Declaracion de arreglos ---
	Dimension MarcoOcupado[4]
	Dimension MarcoPagina[4]
	Dimension Presente[6]
	Dimension MarcoDePagina[6]
	Dimension Referencias[12]
	
	// --- Cargar secuencia del enunciado ---
	Referencias[0]  <- 1
	Referencias[1]  <- 2
	Referencias[2]  <- 3
	Referencias[3]  <- 4
	Referencias[4]  <- 1
	Referencias[5]  <- 2
	Referencias[6]  <- 5
	Referencias[7]  <- 1
	Referencias[8]  <- 2
	Referencias[9]  <- 3
	Referencias[10] <- 4
	Referencias[11] <- 5
	
	Escribir "============================================"
	Escribir "   SIMULADOR MMU - Gestion de Memoria"
	Escribir "   Modulo: AdministradorMemoria"
	Escribir "============================================"
	
	// ---- FASE 1: Mapa de Bits ----
	Escribir ""
	Escribir "--- FASE 1: Inicializacion de RAM ---"
	InicializarRAM(MarcoOcupado, MarcoPagina)
	Escribir "Estado inicial:"
	MostrarMapaBits(MarcoOcupado, MarcoPagina)
	
	// Simular carga de paginas para demostrar mapa de bits
	MarcoOcupado[0] <- 1
	MarcoPagina[0]  <- 1
	MarcoOcupado[1] <- 1
	MarcoPagina[1]  <- 2
	Escribir ""
	Escribir "Tras cargar P1 en M0 y P2 en M1:"
	MostrarMapaBits(MarcoOcupado, MarcoPagina)
	
	// ---- FASE 2: Traduccion de Direcciones ----
	Escribir ""
	Escribir "--- FASE 2: Traduccion de Direcciones (MMU) ---"
	
	Para i <- 0 Hasta 5
		Presente[i]      <- 0
		MarcoDePagina[i] <- -1
	FinPara
	Presente[1]      <- 1
	MarcoDePagina[1] <- 0
	Presente[2]      <- 1
	MarcoDePagina[2] <- 1
	
	dir <- TraducirDireccion(Presente, MarcoDePagina, 1, 100)
	Si dir = -1 Entonces
		Escribir "Pagina 1, offset 100 -> FALLO DE PAGINA"
	Sino
		Escribir "Pagina 1, offset 100 -> Direccion fisica: ", dir
	FinSi
	
	dir <- TraducirDireccion(Presente, MarcoDePagina, 2, 200)
	Si dir = -1 Entonces
		Escribir "Pagina 2, offset 200 -> FALLO DE PAGINA"
	Sino
		Escribir "Pagina 2, offset 200 -> Direccion fisica: ", dir
	FinSi
	
	dir <- TraducirDireccion(Presente, MarcoDePagina, 3, 50)
	Si dir = -1 Entonces
		Escribir "Pagina 3, offset 50  -> FALLO DE PAGINA (no esta en RAM)"
	Sino
		Escribir "Pagina 3, offset 50  -> Direccion fisica: ", dir
	FinSi
	
	// ---- FASE 3 y 4: Algoritmos de Reemplazo ----
	Escribir ""
	Escribir "--- FASE 3 y 4: Algoritmos de Reemplazo ---"
	Escribir "Secuencia: [1,2,3,4,1,2,5,1,2,3,4,5]"
	Escribir "Marcos disponibles para usuario: 3"
	
	fallosFIFO <- SimularFIFO(Referencias)
	fallosOPT  <- SimularOPT(Referencias)
	
	// ---- Resultados Finales ----
	Escribir ""
	Escribir "============================================"
	Escribir "           RESULTADOS FINALES"
	Escribir "============================================"
	Escribir "Fallos de pagina FIFO : ", fallosFIFO
	Escribir "Fallos de pagina OPT  : ", fallosOPT
	Escribir "Diferencia            : ", fallosFIFO - fallosOPT, " fallos menos con OPT"
	Escribir ""
	Escribir "OPT es teoricamente optimo: no puede existir"
	Escribir "algoritmo con menos fallos que OPT."

FinProceso
