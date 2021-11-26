const { description } = require('../package')
const getConfig = require("vuepress-bar");

module.exports = {
  /**
   * Ref：https://v1.vuepress.vuejs.org/config/#title
   */
  title: 'AGATA',
  base: '/agata/',
  /**
   * Ref：https://v1.vuepress.vuejs.org/config/#description
   */
  description: description,

  /**
   * Extra tags to be injected to the page HTML `<head>`
   *
   * ref：https://v1.vuepress.vuejs.org/config/#head
   */
  head: [
    ['meta', { name: 'theme-color', content: '#56772c' }],
    ['link', { rel: 'icon', href: '/agata-logo.png' }],
    ['meta', { name: 'apple-mobile-web-app-capable', content: 'yes' }],
    ['meta', { name: 'apple-mobile-web-app-status-bar-style', content: 'black' }]
  ],

  /**
   * Theme configuration, here is the default theme configuration for VuePress.
   *
   * ref：https://v1.vuepress.vuejs.org/theme/default-theme-config.html
   */
  themeConfig: {
    repo: '',
    editLinks: false,
    docsDir: '',
    editLinkText: '',
    lastUpdated: false,
    nav: [
      {
        text: 'Guides',
        link: '/guides/',
      },
      {
        text: 'API Docs',
        link: '/api/'
      },
    ],
    sidebar: {
      '/guides/': [
        {
          title: 'Guides',
          collapsable: false,
          children: [
            'getstarted',
            'listFunctionalities',
            'contribute-guide',
            'contribute-new-feature',
          ]
        }
      ],
      '/api/': [
        {
          title: 'AGATA Reference',
          collapsable: false,
          children: [
            'analysis',
            'time',
            'variabilityMetrics',
            'errorMetrics',
            'riskMetrics',
            'glyTransMetrics',
            'processing',
            'inspection',
            'utilities',
            'visualization',
          ]
        },
      ],
    }

  },

  markdown: {
    config: md => {
      md.use(require("markdown-it-katex"));
    }
  },

  /**
   * Apply plugins，ref：https://v1.vuepress.vuejs.org/zh/plugin/
   */
  plugins: [
    '@vuepress/plugin-back-to-top',
    '@vuepress/plugin-medium-zoom',
  ]
}

