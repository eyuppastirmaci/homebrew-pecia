# Homebrew formula for the eyuppastirmaci/pecia tap, rendered by the release workflow for each version.
class Pecia < Formula
  desc "Offline lexical and semantic search for documents and source code"
  homepage "https://github.com/eyuppastirmaci/pecia"
  license "MIT"

  on_macos do
    # ONNX Runtime has no Intel macOS build, so only Apple silicon has a package.
    depends_on arch: :arm64

    on_arm do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.1/pecia-0.1.1-osx-aarch64.tar.gz"
      sha256 "457fd64571800c77b227a7d2059f05f848b00868a09a8b92934ef3f6dabd3ca6"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.1/pecia-0.1.1-linux-x64.tar.gz"
      sha256 "338c098e8afbaf5abb063f379f4a55ad678f134a571580058a447da71ffe7b8a"
    end

    on_arm do
      url "https://github.com/eyuppastirmaci/pecia/releases/download/v0.1.1/pecia-0.1.1-linux-aarch64.tar.gz"
      sha256 "97f4f33c164c068459487f8a20052f8ecc21ca5e6f2824317ae93f126235349a"
    end
  end

  def install
    # The package bundles its own Java runtime; its launcher finds it through this link.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pecia"
  end

  test do
    assert_match "pecia #{version}", shell_output("#{bin}/pecia --version")

    (testpath/"refunds.md").write "# Refunds\n\nMoney goes back to the original card.\n"
    system bin/"pecia", "init"
    system bin/"pecia", "index", "--progress=none"
    assert_match "refunds.md", shell_output("#{bin}/pecia query refunds")
  end
end
