require 'erb'

class NotesHTMLGenerator

  def initialize(binding)
    @binding = binding
    @template = %q{

    <html>
      <head>
        <title> All Notes </title>
      </head>

      <body>
        <h1> Notes </h1>
        <% notes.each do |note| %>
          <section>
            <h2> <%= note.title %> </h2>
            <p> <%= note.contents %> </p>
          </section>
        <% end %>
      <body>

    </html>
}
    @rhtml = ERB.new(@template)
  end

  def run
    @rhtml.result(@binding)
  end

end
