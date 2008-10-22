module ParameterizedSnippets
  module PageExt

    include Radiant::Taggable

    desc %{
      Renders the containing elements only if the snippet was called with a certain parameter.
      If an additional "matches" parameter containing a regular expression is used, the containing
      elements are only rendered if the parameter exists and matches the regular expression.
      
      *Usage:*
      
      <pre><code><r:if_var name="parameter_name" [matches="regex"]>...</r:if_var></code></pre>
      
      *Example:*
      
      Some page:
      
      <pre><code><r:snippet name="animal_info" animal="elephant" /></code></pre>

      animal_info snippet:
      
      <pre><code><r:if_var name="animal" matches=".le(?:ph|f)ant">...</r:if_var></code></pre>
    }
    tag 'snippet:if_var' do |tag|
      tag.expand if var_exists_and_matches(tag)
    end

    desc %{
      The opposite of the @if_var@ tag.
      
      *Usage:*
      
      <pre><code><r:unless_var name="parameter_name" [matches="regex"]>...</r:unless_var></code></pre>
    }
    tag 'snippet:unless_var' do |tag|
      tag.expand unless var_exists_and_matches(tag)
    end

    desc %{
      Outputs the value of the parameter or an error message if the parameter cannot be found.
      
      *Usage:*

      <pre><code><r:var name="parameter_name" /></code></pre>
      
      *Example:*
      
      Some page:
      
      <pre><code><r:snippet name="animal_info" animal="elephant" /></code></pre>

      animal_info snippet:
      
      <pre><code><r:var name="animal" /> # Outputs 'elephant'</code></pre>
    }
    tag 'snippet:var' do |tag|
      var = check_for_attr(tag, 'name')
      tag_binding = get_snippet_tag_binding(tag)
      if tag_binding && tag_binding.attr[var]
        tag_binding.attr[var]
      else
        "Could not find parameter '#{var}' in snippet '#{tag_binding.attributes['name']}'."
      end
    end

    protected

      def check_for_attr(tag, attr)
        returning type = tag.attr[attr.to_s].to_s do
          raise TagError, "Please define the '#{attr}' attribute for the tag '#{tag.name}'." unless type
        end
      end

      def get_snippet_tag_binding(tag)
        tag.context.instance_variable_get(:@tag_binding_stack).reverse.detect { |tag_binding| tag_binding.name == 'snippet' }
      end

      def var_exists_and_matches(tag)
        var = check_for_attr(tag, 'name')
        content = get_content_from_tag_binding(tag)
        if tag.attr['matches']
          content.attr[var] =~ /^#{tag.attr['matches']}$/
        else
          content.attr[var]
        end
      end

  end
end

