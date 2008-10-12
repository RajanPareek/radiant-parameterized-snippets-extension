# require_dependency 'application'

class ParameterizedSnippetsExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/parameterized_snippets"

  def activate
    Page.send :include, ParameterizedSnippets::PageExt
  end

  def deactivate
  end

end

