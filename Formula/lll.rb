# Homebrew formula template for lll. The release workflow
# (.github/workflows/release.yml) renders this on every v* tag: it replaces
# the __MARKERS__ below with the tag version and the sha256 of each release
# binary, then pushes the result to the tap repo (default
# escherize/homebrew-lll, override with TAP_REPO).
#
# Binary names here must match the artifacts the release workflow attaches:
# dist/lll-darwin-arm64, dist/lll-linux-amd64, dist/lll-linux-arm64.
#
# Until the tap repo exists and a TAP_TOKEN secret is set, the workflow skips
# the tap push and this template is the source of truth to copy by hand.

class Lll < Formula
  desc "Linear-style issue tracker that runs from a single binary"
  homepage "https://github.com/escherize/lll"
  version "0.9.0"

  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-darwin-arm64"
      sha256 "74208f65eb6ef10ac84076b982a48392c1e13f3ccfaf72d4d6f94d7f74fdf5fa"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-amd64"
      sha256 "3d4aeebf07caca9b6d3429b0d88fc3eb5cb672c0cddb201c6fcb92f5981fbdf6"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-arm64"
      sha256 "25805c2c3e3bfa576a4047c0a4eec8d9e0dd0b6e9d80f935a5e67c76cb3b90ac"
    end
  end

  def install
    # Release assets are bare binaries named per platform; the staged file
    # keeps that name, so install renames it to lll. (Verified by a real
    # `brew install escherize/lll/lll` against the v0.2.0 tap.)
    if OS.mac?
      bin.install "lll-darwin-arm64" => "lll"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "lll-linux-amd64" => "lll"
    else
      bin.install "lll-linux-arm64" => "lll"
    end
  end

  def caveats
    <<~EOS
      lll up (the board server) reads pb/ from disk and wants a checkout.
      The client commands work from this binary alone.
    EOS
  end

  test do
    assert_match "lll #{version}", shell_output("#{bin}/lll --version")
  end
end
