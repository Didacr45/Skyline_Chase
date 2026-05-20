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

// ─────────────────────────────────────────────
// HOVER LINKS
// ─────────────────────────────────────────────
document
  .querySelectorAll("a, button, .feat-card, .dl-btn, .ctrl-row, .share-btn")
  .forEach((el) => {
    el.addEventListener("mouseenter", () => {
      coin.classList.add("hovering");
    });
    el.addEventListener("mouseleave", () => {
      coin.classList.remove("hovering");
    });
  });
