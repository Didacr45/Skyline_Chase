// ─────────────────────────────────────────────
// CURSOR
// ─────────────────────────────────────────────
const cursor = document.getElementById("cursor");
const star = document.getElementById("cursorStar");

document.addEventListener("mousemove", (e) => {
  cursor.style.left = e.clientX + "px";
  cursor.style.top = e.clientY + "px";

  const trail = document.createElement("div");
  trail.classList.add("cursor-trail");
  trail.style.left = e.clientX + "px";
  trail.style.top = e.clientY + "px";
  document.body.appendChild(trail);

  setTimeout(() => {
    trail.remove();
  }, 600);
});
