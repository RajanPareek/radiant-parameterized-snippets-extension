class ParameterizedSnippetsExtension < Radiant::Extension

  version '1.0'
  description 'Allow sending parameters to snippets'
  url 'http://zoopzoop.net/projects/radiant-parameterized-snippets-extension'

  def activate
    Page.send :include, ParameterizedSnippets::PageExt
  end

  def deactivate
  end

end

