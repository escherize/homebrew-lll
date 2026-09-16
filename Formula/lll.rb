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
  version "0.3.1"

  # No license field: the repo does not declare one. Add it here when it does.

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-darwin-arm64"
      sha256 "29dd330b5142add09eeab1dad279bfeccb8c9eb485411a9cbff3a2c8276a7a9a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-amd64"
      sha256 "7fb3410081a499a7513d14f01b7607f9440da66a1de662f4142221dd097a1e47"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-arm64"
      sha256 "c59bf47b92f984258579147697f19d7dcde7cd25c18f61850155c563ba0b10ca"
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
