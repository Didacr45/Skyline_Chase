const cursor = document.querySelector('.cursor-personalizado');

document.addEventListener('mousemove', (e) => {
  // Mueve el div a la posición exacta del cursor
  cursor.style.left = e.clientX + 'px';
  cursor.style.top = e.clientY + 'px';
});