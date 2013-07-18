#

# A simple liquid tag for Jekyll/Octopress that converts {% m %}
# and {% em %} into inline math, and {% math %} and {% endmath %}
# into block equations, by replacing with the appropriate MathJax
# script tags.
module Jekyll
  class MathJaxBlockTag < Liquid::Tag
    def render(context)
      '<script type="math/tex; mode=display">'
    end
  end
  class MathJaxInlineTag < Liquid::Tag
    def render(context)
    '<script type="math/tex">'
    end
  end
  class MathJaxEndTag < Liquid::Tag
    def render(context)
      '</script>'
    end
  end
end
 
Liquid::Template.register_tag('math', Jekyll::MathJaxBlockTag)
Liquid::Template.register_tag('m', Jekyll::MathJaxInlineTag)
Liquid::Template.register_tag('endmath', Jekyll::MathJaxEndTag)
Liquid::Template.register_tag('em', Jekyll::MathJaxEndTag)

