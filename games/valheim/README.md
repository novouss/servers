## Setup

> [!WARNING]
> You will need to have Valheim Dedicated Server (included after buying Valheim)

## Modifiers

| Modifier     | Default                                         | Valid Values                                                                    |
|---|---|---|
| combat       | normal (100%)                                   | `veryeasy`, `easy`, `hard`, `veryhard`                                          |
| deathpenalty | normal (5% skill loss)                          | `casual`, `veryeasy`, `easy`, `hard`, `hardcore`                                |
| resources    | normal (1x)                                     | `muchless` (0.5x), `less` (0.75x), `more` (1.15x), `muchmore` (2x), `most` (3x) |
| raids        | normal (100% event rate, ~interval, 20% chance) | `none`, `muchless` (200%), `less` (150%), `more` (60%), `muchmore` (30%)        |
| portals      | normal                                          | `casual` (carry ore), `hard` (no boss portals), `veryhard` (no portals)         |

### Example

```bash
valheim_server.x86_64 ... -modifier resources most -modifier raids muchless
```
