defmodule AppBuilder do
  defdelegate build_mac_app(release, options), to: AppBuilder.MacOS

  defdelegate build_mac_app_dmg(release, options), to: AppBuilder.MacOS

  defdelegate build_windows_installer(release, options), to: AppBuilder.Windows

  def os do
    case :os.type() do
      {:unix, :darwin} -> :macos
      {:win32, _} -> :windows
    end
  end

  def bundle(release) do
    os = os()

    allowed_options = [
      :name,
      :version,
      icon_path: [
        macos: Application.app_dir(:wx, "examples/demo/erlang.png")
      ],
      url_schemes: [],
      document_types: [],
      additional_paths: [],
      macos_is_agent_app: false,
      macos_build_dmg: false,
      macos_notarization: nil
    ]

    options = Keyword.validate!(release.options[:app], allowed_options)

    case os do
      :macos ->
        AppBuilder.MacOS.bundle(release, options)
    end
  end
end
