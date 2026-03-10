---
name: hello-world-cli
title: Hello World CLI - A Simple Greeting Tool
description: A simple CLI tool that generates personalized greeting messages. Perfect for learning OpenClaw Skill development.
version: 1.0.0
author: LeonardoDpanda
tags: ["cli", "beginner", "tutorial", "greeting"]
---

# Hello World CLI

A simple yet useful CLI tool for generating personalized greeting messages.

## Features

- Generate personalized greetings
- Support multiple languages (English, Spanish, French)
- Customizable greeting templates
- Lightweight and fast

## Installation

```bash
# Clone the repository
git clone https://github.com/LeonardoDpanda/hello-world-cli.git

# Install dependencies
npm install

# Make it executable
chmod +x hello-world.js
```

## Usage

### Basic Greeting

```bash
# Simple greeting
./hello-world.js

# Output: Hello, World!
```

### Personalized Greeting

```bash
# Greet a specific person
./hello-world.js --name "Alice"

# Output: Hello, Alice!
```

### Different Languages

```bash
# Spanish greeting
./hello-world.js --name "Carlos" --lang es

# Output: ¡Hola, Carlos!

# French greeting
./hello-world.js --name "Marie" --lang fr

# Output: Bonjour, Marie!
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| `--name` | Name to greet | "World" |
| `--lang` | Language (en/es/fr) | "en" |
| `--uppercase` | Convert to uppercase | false |

## Examples

### Morning Greeting
```bash
./hello-world.js --name "Team" --lang en
# Output: Good morning, Team!
```

### Formal Greeting
```bash
./hello-world.js --name "Dr. Smith" --uppercase
# Output: HELLO, DR. SMITH!
```

## API Usage

You can also use this as a module:

```javascript
const greet = require('./hello-world');

// Basic usage
console.log(greet('Alice')); // "Hello, Alice!"

// With options
console.log(greet('Bob', { lang: 'es', uppercase: true }));
// "¡HOLA, BOB!"
```

## Configuration

Create a `.hellorc` file in your home directory:

```json
{
  "defaultName": "Developer",
  "defaultLang": "en",
  "theme": "default"
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT-0 License - see the [LICENSE](LICENSE) file for details.

## Author

**LeonardoDpanda**
- GitHub: [@LeonardoDpanda](https://github.com/LeonardoDpanda)

## Acknowledgments

- Inspired by classic "Hello, World!" programs
- Built for the OpenClaw community
