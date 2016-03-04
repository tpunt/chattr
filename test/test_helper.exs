ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Chattr.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Chattr.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Chattr.Repo)

