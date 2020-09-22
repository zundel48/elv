module.exports = {
  purge: [],
  theme: {
    extend: {},
  },
  variants: {},
    plugins: [
	require('tailwindcss-animatecss')({
            classes: ['animate__animated', 'animate__fadeIn', 'animate__bounceIn', 'animate__lightSpeedOut','animate__flipInX'
],
            settings: {
		animatedSpeed: 1000,
		heartBeatSpeed: 1000,
		hingeSpeed: 2000,
		bounceInSpeed: 750,
		bounceOutSpeed: 750,
		animationDelaySpeed: 1000
            },
            variants: ['responsive', 'hover', 'reduced-motion'],
      }),

    ],
  theme: {
    screens: {
      'tablet': '640px',
      // => @media (min-width: 640px) { ... }

      'laptop': '1024px',
      // => @media (min-width: 1024px) { ... }

      'desktop': '1900px',
      // => @media (min-width: 1900px) { ... }

      'sm': '640px',
      // => @media (min-width: 640px) { ... }

      'md': '768px',
      // => @media (min-width: 768px) { ... }

      'lg': '1024px',
      // => @media (min-width: 1024px) { ...}

	'xl': '1280px',
	// => @media (min-width: 1280px) { ... }


    },
  },

}
