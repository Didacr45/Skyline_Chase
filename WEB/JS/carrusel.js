/**
 * SKYLINE CHASE - Carrusel de Galería
 * Maneja el movimiento manual, automático y el redimensionado.
 */

const track = document.getElementById("track");
const nextBtn = document.getElementById("nextBtn");
const prevBtn = document.getElementById("prevBtn");
const images = document.querySelectorAll(".carousel-track img");

let index = 0;
let autoPlayInterval;

/**
 * Función principal para mover el carrusel
 */
function updateCarousel() {
  // Calculamos el ancho de una imagen (que es el mismo de la ventana)
  const width = document.querySelector(".carousel-window").clientWidth;

  // Movemos la "tira" de imágenes (track) hacia la izquierda
  track.style.transform = `translateX(${-index * width}px)`;
}

/**
 * Lógica para avanzar a la siguiente imagen
 */
function nextImage() {
  index++;
  // Si llegamos al final, volvemos a la primera
  if (index >= images.length) {
    index = 0;
  }
  updateCarousel();
}

/**
 * Lógica para retroceder a la imagen anterior
 */
function prevImage() {
  index--;
  // Si estamos en la primera y damos atrás, vamos a la última
  if (index < 0) {
    index = images.length - 1;
  }
  updateCarousel();
}

/**
 * Control del movimiento automático (Auto-play)
 */
function startAutoPlay() {
  // Cambia de imagen cada 5 segundos (5000ms)
  autoPlayInterval = setInterval(nextImage, 5000);
}

function stopAutoPlay() {
  clearInterval(autoPlayInterval);
}

// --- EVENTOS DE USUARIO ---

// Clic en botones
nextBtn.addEventListener("click", () => {
  nextImage();
  // Reiniciamos el tiempo al hacer clic manual para que no salte de golpe
  stopAutoPlay();
  startAutoPlay();
});

prevBtn.addEventListener("click", () => {
  prevImage();
  stopAutoPlay();
  startAutoPlay();
});

// Detener el auto-play cuando el ratón está encima (para ver bien una foto)
const carouselWindow = document.querySelector(".carousel-window");

carouselWindow.addEventListener("mouseenter", stopAutoPlay);
carouselWindow.addEventListener("mouseleave", startAutoPlay);

// Ajustar el carrusel si el usuario cambia el tamaño del navegador
window.addEventListener("resize", updateCarousel);

// --- INICIO ---
// Lanzamos el carrusel y el auto-play al cargar la página
updateCarousel();
startAutoPlay();
