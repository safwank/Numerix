Code.require_file("test/list_helper.exs")
Code.require_file("test/data_helper.exs")
Code.require_file("test/property_helper.exs")

ExCheck.start()
ExUnit.start()

Application.ensure_all_started(:stream_data)
