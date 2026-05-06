const monthDisplay = document.getElementById("monthDisplay");
const calendarDays = document.getElementById("calendarDays");
let date = new Date();

function renderCalendar() {
  calendarDays.innerHTML = "";
  const month = date.getMonth();
  const year = date.getFullYear();

  // Mostrar mes y año
  monthDisplay.innerText = `${date.toLocaleString("es-ES", {
    month: "long",
  })} ${year}`;

  const firstDayIndex = new Date(year, month, 1).getDay();
  const lastDay = new Date(year, month + 1, 0).getDate();

  // 1. Espacios en blanco (días del mes anterior)
  for (let x = firstDayIndex; x > 0; x--) {
    const emptyDiv = document.createElement("div");
    calendarDays.appendChild(emptyDiv);
  }

  // 2. Crear los días del mes
  for (let i = 1; i <= lastDay; i++) {
    const daySquare = document.createElement("div");
    daySquare.classList.add("day");
    daySquare.innerText = i;

    // Intentar recuperar la tarea guardada para este día específico
    const key = `task-${year}-${month}-${i}`;
    const savedTask = localStorage.getItem(key);

    // Si hay una tarea, añadimos el punto rojo (clase CSS)
    if (savedTask) {
      daySquare.classList.add("has-event");
      // Opcional: ver el texto al dejar el ratón encima
      daySquare.title = savedTask;
    }

    // Acción al hacer clic
    daySquare.onclick = () => {
      // El prompt muestra el texto guardado (si existe) para poder leerlo/editarlo
      const task = prompt(`Log del día ${i}/${month + 1}:`, savedTask || "");

      if (task !== null) {
        // Si no pulsó "Cancelar"
        if (task.trim() !== "") {
          // Guardar y añadir punto rojo
          localStorage.setItem(key, task);
          daySquare.classList.add("has-event");
          daySquare.title = task;
        } else {
          // Si deja el texto vacío, borramos la tarea
          localStorage.removeItem(key);
          daySquare.classList.remove("has-event");
          daySquare.removeAttribute("title");
        }
        // Refrescamos para que los cambios visuales sean inmediatos
        renderCalendar();
      }
    };

    calendarDays.appendChild(daySquare);
  }
}

// Lógica de los botones de navegación
document.getElementById("prevMonth").onclick = () => {
  date.setDate(1);
  date.setMonth(date.getMonth() - 1);
  renderCalendar();
};

document.getElementById("nextMonth").onclick = () => {
  date.setDate(1);
  date.setMonth(date.getMonth() + 1);
  renderCalendar();
};

// Ejecución inicial
renderCalendar();
