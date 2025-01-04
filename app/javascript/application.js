
// Rails modules
import Rails from "@rails/ujs"
import "@rails/activestorage";
import "channels";
import "bootstrap";
import "../assets/stylesheets/application.scss"
import Turbolinks from "turbolinks"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", () => {
    const tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map((tooltipTriggerEl) => {
    return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});
