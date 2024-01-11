const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',

  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
        'dancing-script': ['Dancing Script', 'cursive'],
        'eczar': ['Eczar', 'serif'],
        'fira-sans': ['Fira Sans', 'sans-serif'],
        'source-serif-pro': ['Source Serif Pro', 'serif'],
      },
      backgroundColor: {
        'maroon': '#500000',
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}
