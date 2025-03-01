{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  platformdirs,
  pyyaml,
  setuptools-scm,
  pytest-check,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "craft-cli";
  version = "2.13.0";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "craft-cli";
    tag = version;
    hash = "sha256-IqK+eU2z63yDMJrHAhETHWoTz5lWK1er9bwYH9Oml18=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.2.0" "setuptools"
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    platformdirs
    pyyaml
  ];

  pythonImportsCheck = [ "craft_cli" ];

  nativeCheckInputs = [
    pytest-check
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/unit" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI builder for Canonical's CLI Guidelines";
    homepage = "https://github.com/canonical/craft-cli";
    changelog = "https://github.com/canonical/craft-cli/releases/tag/${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ jnsgruk ];
    platforms = lib.platforms.linux;
  };
}
