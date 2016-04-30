Code.require_file("spec/data_helper.exs")

ESpec.configure fn(config) ->
  config.before fn ->
    {:shared, hello: :world}
  end

  config.finally fn(_shared) ->
    :ok
  end
end
