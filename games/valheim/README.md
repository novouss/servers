## Setup

## Modifiers

| Modifier     | Default                                         | Valid Values                                                                    |
|---|---|---|
| combat       | normal (100%)                                   | `veryeasy`, `easy`, `hard`, `veryhard`                                          |
| deathpenalty | normal (5% skill loss)                          | `casual`, `veryeasy`, `easy`, `hard`, `hardcore`                                |
| resources    | normal (1x)                                     | `muchless` (0.5x), `less` (0.75x), `more` (1.15x), `muchmore` (2x), `most` (3x) |
| raids        | normal (20% chance every 46 minutes) | `none`, `muchless` (10%, 92mins), `less` (13.33%, 69mins), `more` (33.3%, 27.6mins), `muchmore` (66.67%, 13.8mins)        |
| portals      | normal                                          | `casual` (carry ore), `hard` (no boss portals), `veryhard` (no portals)         |

### Example

```bash
valheim_server.x86_64 ... -modifier resources most -modifier raids muchless
```
