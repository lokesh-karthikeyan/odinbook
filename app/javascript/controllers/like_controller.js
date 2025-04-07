import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="like"
export default class extends Controller {
  static targets = ["button"];

  connect() {}

  toggleLike(event) {
    event.preventDefault();

    const button = event.currentTarget;
    const url = button.dataset.url;
    const isLiked = button.dataset.liked === "true";

    fetch(url, {
      method: isLiked ? "DELETE" : "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
    })
      .then((response) => {
        if (!response.ok) throw new Error("Network response was not ok");
        return response.json();
      })
      .then((data) => {
        const newLikeCount = data.like_count;
        button.textContent = `${newLikeCount} Likes`;
        button.classList.toggle("is-success", !isLiked);
        button.dataset.liked = (!isLiked).toString();
        button.dataset.url = isLiked
          ? button.dataset.url.replace("unlike", "like")
          : button.dataset.url.replace("like", "unlike");
      })
      .catch((error) => console.error("Error:", error));
  }
}
