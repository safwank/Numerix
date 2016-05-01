Code.require_file("spec/data_helper.exs")
Path.wildcard("spec/support/**/*.exs") |> Enum.each(&Code.require_file/1)

ESpec.configure fn(config) ->
  config.before fn ->
    {:shared, hello: :world}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
