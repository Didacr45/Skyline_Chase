const monthDisplay = document.getElementById("monthDisplay");
const calendarDays = document.getElementById("calendarDays");
let date = new Date();

function renderCalendar() {
  calendarDays.innerHTML = "";
  const month = date.getMonth();
  const year = date.getFullYear();

  monthDisplay.innerText = `${date.toLocaleString("es-ES", {
    month: "long",
  })} ${year}`;

  const firstDayIndex = new Date(year, month, 1).getDay();
  const lastDay = new Date(year, month + 1, 0).getDate();

  // Espacios vacíos para los días del mes anterior
  for (let x = firstDayIndex; x > 0; x--) {
    const emptyDiv = document.createElement("div");
    calendarDays.appendChild(emptyDiv);
  }

  // Crear los días del mes
  for (let i = 1; i <= lastDay; i++) {
    const daySquare = document.createElement("div");
    daySquare.classList.add("day");
    daySquare.innerText = i;

    // Acción al hacer clic
    daySquare.onclick = () => {
      const task = prompt(`¿Qué hicieron el día ${i}?`);
      if (task) {
        daySquare.classList.add("has-event");
        // Aquí podrías guardar 'task' en una base de datos o localStorage
        console.log(`Día ${i}: ${task}`);
      }
    };

    calendarDays.appendChild(daySquare);
  }
}

renderCalendar();
