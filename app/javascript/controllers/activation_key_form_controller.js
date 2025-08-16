import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ossFields"]

  connect() {
    this.toggleOss()
  }

  toggleOss() {
    const checkbox = this.element.querySelector('input[name="activation_key[free_for_open_source]"]')
    if (!checkbox) return

    const projectNameInput = this.element.querySelector('input[name="activation_key[project_name]"]')
    const projectUrlInput = this.element.querySelector('input[name="activation_key[project_url]"]')
    const projectNameLabel = this.element.querySelector('#label_project_name')
    const projectUrlLabel = this.element.querySelector('#label_project_url')

    if (checkbox.checked) {
      if (projectNameInput) projectNameInput.setAttribute('required', 'required')
      if (projectUrlInput) projectUrlInput.setAttribute('required', 'required')
      if (projectNameLabel) this.addAsterisk(projectNameLabel)
      if (projectUrlLabel) this.addAsterisk(projectUrlLabel)
    } else {
      if (projectNameInput) projectNameInput.removeAttribute('required')
      if (projectUrlInput) projectUrlInput.removeAttribute('required')
      if (projectNameLabel) this.removeAsterisk(projectNameLabel)
      if (projectUrlLabel) this.removeAsterisk(projectUrlLabel)
    }
  }

  addAsterisk(labelEl) {
    const text = labelEl.textContent.trim()
    if (!text.endsWith('*')) {
      labelEl.textContent = text + '*'
    }
  }

  removeAsterisk(labelEl) {
    const text = labelEl.textContent.trim()
    if (text.endsWith('*')) {
      labelEl.textContent = text.slice(0, -1)
    }
  }
}
