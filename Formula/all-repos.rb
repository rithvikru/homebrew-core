class AllRepos < Formula
  include Language::Python::Virtualenv

  desc "Clone all your repositories and apply sweeping changes"
  homepage "https://github.com/asottile/all-repos"
  url "https://files.pythonhosted.org/packages/9a/ea/cdabb519e8afc76df7d70b900403d4f118404c90665d4468c88101265c47/all_repos-1.26.0.tar.gz"
  sha256 "52fd543c17064af11c06cfe344bb43eda550f5a69de2be767d5c98661a0783b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "180abab58ecc446d8045449cd0a601dd48ec223cfba9289b5d931e7273cd000a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c678f94a52097856b6799ed8dd4c87e28dc52ad0a221c3a5c73f4cee009a5c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4682db5be5c8e6afbff8650bddf5ba4a2c4c65246267fcf789194184e3f6567"
    sha256 cellar: :any_skip_relocation, ventura:        "72beee3ac81491cf4a819ff64c697ef0f55184df892f0a8b8b9a474736afa507"
    sha256 cellar: :any_skip_relocation, monterey:       "e03dfac164b84ce9c2295d2a5005ff96e90c2efbbf6ef1bd86252212a1e47d94"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cfed750da5b85bd9fc56206f1edfdab3d79801f6c688dedeed5330b5aaa032f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7572ac9c563d044496856824043ff5f1d9eda0038cb98398fee7aad9a882a11"
  end

  depends_on "python@3.11"

  resource "identify" do
    url "https://files.pythonhosted.org/packages/c4/f8/498e13e408d25ee6ff04aa0acbf91ad8e9caae74be91720fc0e811e649b7/identify-2.5.24.tar.gz"
    sha256 "0aac67d5b4812498056d28a9a512a483f5085cc28640b02b258a59dac34301d4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"all-repos.json").write <<~EOS
      {
        "output_dir": "out",
        "source": "all_repos.source.json_file",
        "source_settings": {"filename": "repos.json"},
        "push": "all_repos.push.readonly",
        "push_settings": {}
      }
    EOS
    chmod 0600, "all-repos.json"
    (testpath/"repos.json").write <<~EOS
      {"discussions": "https://github.com/Homebrew/discussions"}
    EOS

    system bin/"all-repos-clone"
    assert_predicate testpath/"out/discussions", :exist?
    output = shell_output("#{bin}/all-repos-grep discussions")
    assert_match "out/discussions:README.md", output
  end
end
