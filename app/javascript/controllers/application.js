import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

// Rails modules
import Rails from "@rails/ujs";
Rails.start();

import "@rails/activestorage";
import "channels";

// Bootstrap modules
import "bootstrap";

// Import CSS
import "../assets/stylesheets/application.scss"
// Initialize tooltips
document.addEventListener("DOMContentLoaded", () => {
    const tooltipTriggerList = [].slice.call(
    document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map((tooltipTriggerEl) => {
    return new bootstrap.Tooltip(tooltipTriggerEl);
    });
});

