module ParameterizedSnippets
  module PageExt

    include Radiant::Taggable

    desc %{
      Renders the containing elements only if the snippet was called with a certain parameter.
      
      *Usage:* 
      
      In page "Home":
      
      <pre><code><r:snippet name="animal_info" animal="elephant" /></code></pre>

      In snippet "animal_info":
      
      <pre><code><r:if_var name="animal">...</r:if_var></code></pre>
    }
    tag "snippet:if_var" do |tag|
      var = check_for_attr(tag, 'name')
      content = get_content_from_tag_binding(tag)
      tag.expand if content.attr[var]
    end

    desc %{
      The opposite of the @if_var@ tag.
      
      *Usage:* 
      <pre><code><r:unless_var name="animal">...</r:unless_var></code></pre>
    }
    tag "snippet:unless_var" do |tag|
      var = check_for_attr(tag, 'name')
      content = get_content_from_tag_binding(tag)
      tag.expand unless content.attr[var]
    end

    desc %{
      Outputs the value of the parameter or an error message if the parameter cannot be found.
      
      *Usage:* 
      
      In page "Home":
      
      <pre><code><r:snippet name="animal_info" animal="elephant" /></code></pre>

      In snippet "animal_info":
      
      <pre><code><r:var name="animal" /></code></pre>
    }
    tag "snippet:var" do |tag|
      var = check_for_attr(tag, 'name')
      content = get_content_from_tag_binding(tag)
      if content.blank?
        "Error getting content."
      elsif content.attr[var].nil?
        "Could not find attribute '#{var}'."
      else
        content.attr[var]
      end
    end

    protected

      def check_for_attr(tag, attr)
        returning type = tag.attr[attr.to_s].to_s do
          raise TagError, "Please define the '#{attr}' attribute for the tag '#{tag.name}'." unless type
        end
      end

      def get_content_from_tag_binding(tag)
        tag.context.instance_variable_get(:@tag_binding_stack).detect { |slot| slot.name == 'snippet' }
      end

  end
end

