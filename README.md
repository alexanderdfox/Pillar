# Pillar – AI Chatbot for TempleOS

**Pillar** is a small AI-style chatbot written in **HolyC** for **TempleOS**. It’s rule-based: responses are chosen from built-in data (keywords and reply text). No network or external APIs—everything runs inside the Temple.

## Features

- Conversational loop: you type, Pillar answers.
- Topics: greetings, TempleOS, HolyC, Terry Davis / God, Pillar itself, help, thanks.
- Case-insensitive keyword matching.
- Random variation for some answers.
- Exit with **bye**, **quit**, or **exit**.

## How to run on TempleOS

1. Copy `Pillar.HC` into your TempleOS tree (e.g. under `Home:` or any folder).
2. In the TempleOS shell (or from the editor):
   - **Run from shell:**  
     `Pillar.HC`
   - Or open `Pillar.HC` in the editor and execute it (e.g. run / compile as your setup supports).

3. When it starts, you’ll see a short intro. Type a line and press Enter; Pillar will reply. Repeat until you type **bye** or **quit**.

## Example

```
*** Pillar ***
AI chatbot for TempleOS. Say hello, or ask about TempleOS, HolyC, or God.
Type bye or quit to exit.

You: hello
Pillar: Hello! Welcome to the Temple.

You: what is holyc
Pillar: HolyC is the language of the Temple. C-like, one-pass compiler...

You: bye
Pillar: Peace be with you. Until we talk again.
```

## Requirements

- **TempleOS** (or a HolyC environment that provides `Print`, `GetChar`, `StrLen`, `Rand`).
- If `Rand` is not available, change `PickResponse` to use another source (e.g. `GetTicks() % n`).

## File

- **Pillar.HC** – HolyC source; all logic and “AI” data (keywords and responses) are in this file.
