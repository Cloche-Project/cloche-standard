*[Read in English](README.md)*

<p align="center">
  <picture>
    <img src="cloche-logo/watermark.png" alt="Cloche OS Logo" height="80" />
  </picture>
</p>

<p align="center">
    <strong>Workstation Padrão em RPM-Ostree</strong>
</p>

<p align="center">
  <strong>Cloche Standard</strong> é uma série de imagens de desktop imutáveis e container-native, projetadas como uma workstation sólida para desenvolvedores e sysadmins.
</p>

<p align="center">
  <a href="https://github.com/cloche-project/cloche-standard/actions/workflows/build.yml">
    <img src="https://github.com/cloche-project/cloche-standard/actions/workflows/build.yml/badge.svg" alt="Build Status" />
  </a>
  <a href="https://ghcr.io/cloche-project/cloche-standard-gnome">
    <img src="https://img.shields.io/badge/registry-GHCR-blue?logo=github" alt="GHCR Registry" />
  </a>
  <img src="https://img.shields.io/github/license/cloche-project/cloche-standard" alt="License" />
</p>

> [!NOTE]
> **O Cloche Standard herda diretamente da imagem Cloche Headless Base.** Ele aplica os ambientes gráficos, drivers de hardware e os essenciais de desktop sobre a base segura já existente.

---

## Variantes Disponíveis

| Nome da Imagem | Ambiente Desktop | Caso de Uso |
|------------|---------------------|-----------------|
| `cloche-standard-gnome` | GNOME (nativo Wayland) | Workstation minimalista para desenvolvimento, pronta para extensões |
| `cloche-standard-plasma` | KDE Plasma | Ambiente altamente customizável e rico em recursos para power users |

---

## Arquitetura do Desktop

| Componente | Detalhes |
|-----------|---------|
| **Camada Base** | Cloche Headless Base (`ghcr.io/cloche-project/cloche:latest`) |
| **Servidor Gráfico** | Wayland por padrão (com fallback para XWayland) |
| **Stack de Áudio** | PipeWire (motor de áudio de baixa latência pré-configurado) |
| **Entrega de Apps** | Flatpak (Flathub habilitado no nível de usuário) + Distrobox |
| **Suporte a Hardware** | Drivers gráficos open-source embutidos (Mesa/AMDGPU pronto) |

---

## Principais Recursos do Desktop

* **Separação em Camadas:** O sistema base permanece completamente imutável e limpo. Todas as aplicações de desktop rodam em sandbox via Flatpak, garantindo que atualizações do SO nunca quebrem a configuração do espaço de usuário.
* **Toolkit de Desktop:** Integra os utilitários centrais do headless (`just`, `distrobox`, `tmux`, `tailscale`) com ferramentas gráficas de gerenciamento.
* **Otimizações de Fonte & UI:** Pré-configurado com tipografia geométrica limpa e temas de sistema voltados a longas sessões de desenvolvimento.
* **Workstation Zero-Drift:** Os pacotes do sistema são declarados nas receitas deste repositório. Chega de rodar `dnf install` manualmente em máquinas novas.

---

## Implantação & Instalação

### Rebase Remoto

Para migrar uma workstation Fedora Atomic existente para o Cloche Standard, escolha sua variante preferida e execute:

```bash
# Exemplo: rebase para a variante GNOME
rpm-ostree rebase ostree-unverified-registry:ghcr.io/cloche-project/cloche-standard-gnome:latest

# Ou para a variante Plasma
rpm-ostree rebase ostree-unverified-registry:ghcr.io/cloche-project/cloche-standard-plasma:latest
```

### Aplique as camadas de desktop reiniciando o sistema:

```bash
systemctl reboot
```

### Passos Recomendados Pós-Instalação

* **Verificar Camadas:** Rode `rpm-ostree status` para garantir que a base e os overrides locais estão de acordo com o esperado.
* **Configurar Flatpaks:** Os remotes do Flatpak já vêm configurados no nível do sistema; apps de usuário podem ser adicionados sem privilégios de root via Central de Software ou CLI.

## Verificação & Segurança

Todo build de imagem de desktop é assinado via Sigstore Cosign contra a chave pública de verificação do repositório.

```bash
# Verificar a camada da variante de desktop específica
cosign verify --key cosign.pub ghcr.io/cloche-project/cloche-standard-gnome:latest
```

## Licença & Agradecimentos

* Licenciado sob Apache 2.0
* Herda a segurança central da camada base `cloche-project/cloche`
* Powered by o framework BlueBuild e os engines do projeto Universal Blue
