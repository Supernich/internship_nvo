class Application
  def call(env)
    sleep(3)
    [
      200,
      { 'Content-Type' => 'text/html' },
      ['<h1>Hello</h1>']
    ]
  end
end
