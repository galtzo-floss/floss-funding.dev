# Guardfile for automatic Tailwind CSS builds
# Runs `rake tailwindcss:build` whenever relevant files change.
# Requires gems: guard, guard-rake (added in Gemfile under development group).

guard :rake, task: 'tailwindcss:build' do
  # Stylesheets (including tailwind entry file)
  watch(%r{^app/assets/stylesheets/.+\.(css|scss|sass)$})

  # JavaScript/TypeScript (class names may affect Tailwind purge)
  watch(%r{^app/javascript/.+\.(js|mjs|ts|tsx)$})

  # Views and partials (class names here affect Tailwind)
  watch(%r{^app/views/.+\.(erb|haml|slim)$})

  # Helpers and Ruby view components
  watch(%r{^app/helpers/.+\.rb$})
  watch(%r{^app/components/.+\.(rb|erb|haml|slim)$})

  # Configuration changes that may influence assets
  watch(%r{^config/.+\.(rb|yml)$})

  # Tailwind config (if present in project)
  watch('tailwind.config.js')
  watch('tailwind.config.cjs')
  watch('tailwind.config.ts')
end
