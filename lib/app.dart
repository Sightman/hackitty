import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const HackittyGame());
}

class HackittyGame extends StatelessWidget {
  const HackittyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HACKITTY',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.cyanAccent,
        ),
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String gameState = 'menu';
  int currentLevel = 1;
  Offset playerPosition = const Offset(100, 400);
  Offset mousePosition = const Offset(100, 100);
  int cyberCoins = 0;
  List<Collectible> collectibles = [];
  List<Collectible> playerSkills = [];
  List<NetworkNode> networkNodes = [];
  List<NetworkConnection> networkConnections = [];
  String language = 'en';
  List<Command> commandPool = [];
  List<Command> tracingProgram = [];
  bool isExecutingProgram = false;
  int mainframeCompromised = 0;
  List<String> blockedNodes = [];
  List<String> disconnectedNodes = [];
  List<String> mouseInventory = [];

  final Map<String, Map<String, dynamic>> text = {
    'en': {
      'title': "HACKITTY",
      'subtitle': "Stop Cyber Mouse from Taking Over the Network!",
      'play': "Play",
      'pause': "Pause",
      'reset': "Reset Level",
      'level': "Level",
      'coins': "CryptoCoins",
      'skills': "Skills Unlocked",
      'caught': "Network Secured!",
      'escaped': "Mainframe Compromised!",
      'parentMode': "Ask Parents to Design a Network!",
      'instructions':
          "Program Hackitty's trace route to stop the cyber mouse from reaching the mainframe!",
      'collectiblesTitle': "Hacking skills",
      'howToPlayTitle': "How to Play",
      'howToPlay': [
        "🐱 You are Hackitty, a computer network security specialist",
        "🐭 Stop the AI mouse from compromising the mainframe",
        "🔧 Collect computing tokens",
        "⚡ Program your trace route using drag-and-drop commands",
        "🛡️ Secure the network before it's too late!",
      ],
      'commandPool': "Available Commands",
      'tracingProgram': "Tracing Program",
      'executeProgram': "Execute Trace",
      'clearProgram': "Clear Program",
      'mainframeStatus': "Mainframe Security",
      'networkNodes': "Network Topology",
    },
    'es': {
      'title': "HACKITTY",
      'subtitle': "¡Detén a Ciber Ratón de Tomar Control de la Red!",
      'play': "Jugar",
      'pause': "Pausa",
      'reset': "Reiniciar Nivel",
      'level': "Nivel",
      'coins': "CriptoMonedas",
      'skills': "Habilidades Desbloqueadas",
      'caught': "¡Red Asegurada!",
      'escaped': "¡Servidor Principal Comprometido!",
      'parentMode': "¡Pide a tus Padres que Diseñen una Red!",
      'instructions':
          "¡Programa la ruta de rastreo de Hackitty para detener al ratón cyber antes de que llegue al servidor principal!",
      'collectiblesTitle': "Habilidades de Hackeo",
      'howToPlayTitle': "Cómo Jugar",
      'howToPlay': [
        "🐱 Eres Hackitty, un especialista en seguridad de redes de computadoras",
        "🐭 Detén al ratón IA de comprometer el servidor principal",
        "🔧 Recoge fichas de computación",
        "⚡ Programa tu ruta de rastreo usando comandos arrastrar y soltar",
        "🛡️ ¡Asegura la red antes de que sea demasiado tarde!",
      ],
      'commandPool': "Comandos Disponibles",
      'tracingProgram': "Programa de Rastreo",
      'executeProgram': "Ejecutar Rastreo",
      'clearProgram': "Limpiar Programa",
      'mainframeStatus': "Seguridad del Servidor Principal",
      'networkNodes': "Topología de Red",
    },
  };

  final List<Collectible> collectibleTypes = [
    Collectible(
      id: 'firewall',
      name: {'en': 'Firewall Shield', 'es': 'Escudo Firewall'},
      icon: '🛡️',
      concept: {
        'en': 'Firewall - Network security barrier that filters traffic',
        'es': 'Firewall - Barrera de seguridad que filtra el tráfico de red',
      },
      skill: {
        'en': 'Blocks a node with firewall protection',
        'es': 'Bloquea un nodo con protección firewall',
      },
      command: 'FIREWALL',
      coins: 15,
      mouseEffect: 'bypass_firewall',
    ),
    Collectible(
      id: 'stealth',
      name: {'en': 'Stealth Mode', 'es': 'Modo Sigiloso'},
      icon: '👻',
      concept: {
        'en': 'Stealth - Allows passing through same node as opponent',
        'es': 'Sigilo - Permite pasar por el mismo nodo que el oponente',
      },
      skill: {
        'en': 'Find quickest path to reach the mouse',
        'es': 'Encuentra el camino más rápido para alcanzar al ratón',
      },
      command: 'PATHFIND',
      coins: 20,
      mouseEffect: 'stealth_mode',
    ),
    Collectible(
      id: 'pathfinder',
      name: {'en': 'Network Compass', 'es': 'Brújula de Red'},
      icon: '🧭',
      concept: {
        'en': 'Pathfinding - Calculates optimal network routes',
        'es': 'Búsqueda de rutas - Calcula rutas óptimas de red',
      },
      skill: {
        'en': 'Disconnect a node from the network',
        'es': 'Desconecta un nodo de la red',
      },
      command: 'DISCONNECT',
      coins: 25,
      mouseEffect: 'smart_pathfind',
    ),
    Collectible(
      id: 'disruptor',
      name: {'en': 'Network Disruptor', 'es': 'Disruptor de Red'},
      icon: '⚡',
      concept: {
        'en': 'Network Isolation - Disconnects compromised nodes',
        'es': 'Aislamiento de Red - Desconecta nodos comprometidos',
      },
      skill: {
        'en': 'Advanced network manipulation tools',
        'es': 'Herramientas avanzadas de manipulación de red',
      },
      command: 'ISOLATE',
      coins: 30,
      mouseEffect: 'tunnel_mode',
    ),
  ];

  final List<Command> availableCommands = [
    Command(
      id: 'MOVE_TO_NODE',
      name: 'MOVE TO',
      description: 'Move to a connected node',
      color: Colors.blue.shade600,
    ),
    Command(
      id: 'SCAN_AREA',
      name: 'SCAN',
      description: 'Scan nearby nodes',
      color: Colors.purple.shade600,
    ),
    Command(
      id: 'WAIT',
      name: 'WAIT',
      description: 'Wait one turn',
      color: Colors.grey.shade600,
    ),
  ];

  @override
  void initState() {
    super.initState();
    initializeNetwork(currentLevel);
  }

  void initializeNetwork(int level) {
    final nodes = [
      // Client Access Layer
      NetworkNode(
        id: 'client1',
        x: 50,
        y: 100,
        type: 'workstation',
        name: '🖥️\nClient 1',
      ),
      NetworkNode(
        id: 'client2',
        x: 150,
        y: 100,
        type: 'workstation',
        name: '🖥️\nClient 2',
      ),

      // Load Balancer Layer
      NetworkNode(
        id: 'loadbalancer',
        x: 100,
        y: 200,
        type: 'router',
        name: '🖧\nLoad Balancer',
      ),

      // Citrix Gateway Layer
      NetworkNode(
        id: 'gateway1',
        x: 50,
        y: 300,
        type: 'server',
        name: '🖥\nGateway 1',
      ),
      NetworkNode(
        id: 'gateway2',
        x: 150,
        y: 300,
        type: 'server',
        name: '🖥\nGateway 2',
      ),

      // Session Host Layer
      NetworkNode(
        id: 'sessionhost1',
        x: 25,
        y: 400,
        type: 'server',
        name: '🖥\nSession Host 1',
      ),
      NetworkNode(
        id: 'sessionhost2',
        x: 75,
        y: 400,
        type: 'server',
        name: '🖥\nSession Host 2',
      ),
      NetworkNode(
        id: 'sessionhost3',
        x: 125,
        y: 400,
        type: 'server',
        name: '🖥\nSession Host 3',
      ),
      NetworkNode(
        id: 'sessionhost4',
        x: 175,
        y: 400,
        type: 'server',
        name: '🖥\nSession Host 4',
      ),

      // Database Layer
      NetworkNode(
        id: 'database',
        x: 100,
        y: 500,
        type: 'server',
        name: '🖴\nDatabase Server',
      ),

      // Mainframe
      NetworkNode(
        id: 'mainframe',
        x: 100,
        y: 600,
        type: 'mainframe',
        name: '🖥\nMainframe',
      ),
    ];

    final connections = [
      // Client to Load Balancer
      NetworkConnection(from: 'client1', to: 'loadbalancer'),
      NetworkConnection(from: 'client2', to: 'loadbalancer'),

      // Load Balancer to Gateways
      NetworkConnection(from: 'loadbalancer', to: 'gateway1'),
      NetworkConnection(from: 'loadbalancer', to: 'gateway2'),

      // Gateways to Session Hosts
      NetworkConnection(from: 'gateway1', to: 'sessionhost1'),
      NetworkConnection(from: 'gateway1', to: 'sessionhost2'),
      NetworkConnection(from: 'gateway2', to: 'sessionhost3'),
      NetworkConnection(from: 'gateway2', to: 'sessionhost4'),

      // Session Hosts to Database
      NetworkConnection(from: 'sessionhost1', to: 'database'),
      NetworkConnection(from: 'sessionhost2', to: 'database'),
      NetworkConnection(from: 'sessionhost3', to: 'database'),
      NetworkConnection(from: 'sessionhost4', to: 'database'),

      // Database to Mainframe
      NetworkConnection(from: 'database', to: 'mainframe'),
    ];

    setState(() {
      networkNodes = nodes;
      networkConnections = connections;

      // Place collectibles randomly on nodes (except client nodes and mainframe)
      final availableNodes =
          nodes
              .where(
                (node) =>
                    node.type != 'mainframe' && !node.id.startsWith('client'),
              )
              .toList();

      final levelCollectibles = <Collectible>[];
      final collectibleCount = min(level + 1, 4);

      for (int i = 0; i < collectibleCount; i++) {
        if (availableNodes.isEmpty) break;

        final nodeIndex = Random().nextInt(availableNodes.length);
        final node = availableNodes[nodeIndex];
        final collectible = collectibleTypes[i % collectibleTypes.length]
            .copyWith(x: node.x, y: node.y, nodeId: node.id, collected: false);
        levelCollectibles.add(collectible);
        availableNodes.removeAt(nodeIndex);
      }

      collectibles = levelCollectibles;
      playerPosition = const Offset(100, 400); // Start at a session host
      mousePosition = const Offset(100, 100); // Start at load balancer
      mainframeCompromised = 0;
      tracingProgram = [];
      blockedNodes = [];
      disconnectedNodes = [];
      mouseInventory = [];
      updateCommandPool();
    });
  }

  void updateCommandPool() {
    final commands = [...availableCommands];
    for (final skill in playerSkills) {
      if (skill.command != null) {
        commands.add(
          Command(
            id: skill.command!,
            name: skill.command!,
            description: skill.skill[language]!,
            color: Colors.cyan.shade600,
          ),
        );
      }
    }
    setState(() {
      commandPool = commands;
    });
  }

  List<NetworkNode> findPathToMainframe(Offset startPos) {
    final startNode = findNearestNode(startPos);
    final mainframeNode = networkNodes.firstWhere(
      (node) => node.type == 'mainframe',
    );

    if (startNode == null || mainframeNode == null) return [];

    // Simple BFS pathfinding
    final queue = [
      PathNode(node: startNode, path: [startNode]),
    ];
    final visited = <String>{startNode.id};

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);

      if (current.node.id == mainframeNode.id) {
        return current.path;
      }

      final connections =
          networkConnections
              .where(
                (conn) =>
                    (conn.from == current.node.id ||
                        conn.to == current.node.id) &&
                    !disconnectedNodes.contains(conn.from) &&
                    !disconnectedNodes.contains(conn.to),
              )
              .toList();

      for (final conn in connections) {
        final nextNodeId = conn.from == current.node.id ? conn.to : conn.from;
        final nextNode = networkNodes.firstWhere((n) => n.id == nextNodeId);

        if (!visited.contains(nextNodeId) && nextNode != null) {
          visited.add(nextNodeId);
          queue.add(
            PathNode(node: nextNode, path: [...current.path, nextNode]),
          );
        }
      }
    }

    return [];
  }

  NetworkNode? findNearestNode(Offset position) {
    NetworkNode? nearest;
    double minDistance = double.infinity;

    for (final node in networkNodes) {
      final distance = sqrt(
        pow(node.x - position.dx, 2) + pow(node.y - position.dy, 2),
      );
      if (distance < minDistance) {
        minDistance = distance;
        nearest = node;
      }
    }

    return nearest;
  }

  void moveMouseTowardsMainframe() {
    final currentNode = findNearestNode(mousePosition);
    if (currentNode == null) return;

    // Check if mouse has special abilities
    final hasCompass = mouseInventory.contains('smart_pathfind');
    final hasStealth = mouseInventory.contains('stealth_mode');
    final hasTunnel = mouseInventory.contains('tunnel_mode');

    List<NetworkNode> path;
    if (hasCompass) {
      // Smart pathfinding - always optimal route
      path = findPathToMainframe(mousePosition);
    } else {
      // Random movement towards mainframe
      final availableConnections =
          networkConnections.where((conn) {
            final isConnected =
                conn.from == currentNode.id || conn.to == currentNode.id;
            final isNotBlocked =
                !blockedNodes.contains(conn.from) &&
                !blockedNodes.contains(conn.to);
            final isNotDisconnected =
                !disconnectedNodes.contains(conn.from) &&
                !disconnectedNodes.contains(conn.to);

            // Special abilities
            if (hasTunnel &&
                (disconnectedNodes.contains(conn.from) ||
                    disconnectedNodes.contains(conn.to))) {
              return isConnected; // Can pass through disconnected nodes
            }

            return isConnected && isNotBlocked && isNotDisconnected;
          }).toList();

      if (availableConnections.isNotEmpty) {
        final randomConnection =
            availableConnections[Random().nextInt(availableConnections.length)];
        final nextNodeId =
            randomConnection.from == currentNode.id
                ? randomConnection.to
                : randomConnection.from;
        final nextNode = networkNodes.firstWhere((n) => n.id == nextNodeId);
        path = nextNode != null ? [currentNode, nextNode] : [currentNode];
      } else {
        path = [currentNode];
      }
    }

    if (path.length > 1) {
      final nextNode = path[1];
      setState(() {
        mousePosition = Offset(nextNode.x.toDouble(), nextNode.y.toDouble());
      });

      // Check if mouse reached mainframe
      if (nextNode.type == 'mainframe') {
        setState(() {
          mainframeCompromised = 100;
          gameState = 'game-over';
        });
      }

      // Check for collectibles
      final collectible = collectibles.firstWhere(
        (c) => c.nodeId == nextNode.id && !c.collected,
        orElse: () => Collectible.empty(),
      );
      if (collectible.id != null) {
        setState(() {
          collectibles =
              collectibles
                  .map(
                    (c) =>
                        c.nodeId == nextNode.id
                            ? c.copyWith(collected: true)
                            : c,
                  )
                  .toList();
          mouseInventory = [...mouseInventory, collectible.mouseEffect];
          mainframeCompromised = min(100, mainframeCompromised + 15);
        });
      }
    }
  }

  Future<void> executeTracingProgram() async {
    if (tracingProgram.isEmpty || isExecutingProgram) return;

    setState(() {
      isExecutingProgram = true;
      gameState = 'playing';
    });

    for (int i = 0; i < tracingProgram.length; i++) {
      final command = tracingProgram[i];
      await Future.delayed(const Duration(milliseconds: 1000));

      switch (command.id) {
        case 'MOVE_TO_NODE':
          movePlayerToNearestNode();
          break;
        case 'FIREWALL':
          activateFirewall();
          break;
        case 'PATHFIND':
          findPathToMouse();
          break;
        case 'DISCONNECT':
          disconnectNode();
          break;
        case 'SCAN_AREA':
          scanArea();
          break;
        case 'WAIT':
          // Just wait
          break;
        default:
          break;
      }

      await Future.delayed(const Duration(milliseconds: 500));

      // Mouse moves after each player action
      if (gameState == 'playing') {
        moveMouseTowardsMainframe();
      }
    }

    setState(() {
      isExecutingProgram = false;
    });
  }

  void movePlayerToNearestNode() {
    final currentNode = findNearestNode(playerPosition);
    if (currentNode == null) return;

    final availableConnections =
        networkConnections
            .where(
              (conn) =>
                  conn.from == currentNode.id || conn.to == currentNode.id,
            )
            .toList();

    if (availableConnections.isNotEmpty) {
      final randomConnection =
          availableConnections[Random().nextInt(availableConnections.length)];
      final nextNodeId =
          randomConnection.from == currentNode.id
              ? randomConnection.to
              : randomConnection.from;
      final nextNode = networkNodes.firstWhere((n) => n.id == nextNodeId);

      if (nextNode != null) {
        setState(() {
          playerPosition = Offset(nextNode.x.toDouble(), nextNode.y.toDouble());
        });

        // Check for collectibles
        final collectible = collectibles.firstWhere(
          (c) => c.nodeId == nextNode.id && !c.collected,
          orElse: () => Collectible.empty(),
        );
        if (collectible.id != null) {
          setState(() {
            collectibles =
                collectibles
                    .map(
                      (c) =>
                          c.nodeId == nextNode.id
                              ? c.copyWith(collected: true)
                              : c,
                    )
                    .toList();
            cyberCoins += collectible.coins;
            playerSkills = [...playerSkills, collectible];
            updateCommandPool();
          });
        }
      }
    }
  }

  void activateFirewall() {
    final nearestNode = findNearestNode(playerPosition);
    if (nearestNode != null && !blockedNodes.contains(nearestNode.id)) {
      setState(() {
        blockedNodes = [...blockedNodes, nearestNode.id];
      });
    }
  }

  void findPathToMouse() {
    final mouseNode = findNearestNode(mousePosition);
    final playerNode = findNearestNode(playerPosition);

    if (mouseNode != null && playerNode != null) {
      // Simple pathfinding - move towards mouse
      final dx = mouseNode.x - playerNode.x;
      final dy = mouseNode.y - playerNode.y;

      if (dx.abs() > dy.abs()) {
        setState(() {
          playerPosition = Offset(
            playerPosition.dx + dx.sign * 50,
            playerPosition.dy,
          );
        });
      } else {
        setState(() {
          playerPosition = Offset(
            playerPosition.dx,
            playerPosition.dy + dy.sign * 50,
          );
        });
      }
    }
  }

  void disconnectNode() {
    final nearestNode = findNearestNode(playerPosition);
    if (nearestNode != null &&
        nearestNode.type != 'mainframe' &&
        !disconnectedNodes.contains(nearestNode.id)) {
      setState(() {
        disconnectedNodes = [...disconnectedNodes, nearestNode.id];
      });
    }
  }

  void scanArea() {
    // Visual effect - could add temporary highlighting
    debugPrint("Scanning area...");
  }

  Color getNodeColor(String nodeType, bool isMainframe, int compromised) {
    if (nodeType == 'mainframe') {
      return compromised > 0 ? Colors.red.shade400 : Colors.blue.shade400;
    }

    switch (nodeType) {
      case 'workstation':
        return Colors.blue.shade400;
      case 'smartphone':
        return Colors.green.shade400;
      case 'server':
        return Colors.purple.shade400;
      case 'router':
        return Colors.orange.shade400;
      case 'switch':
        return Colors.yellow.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Widget buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(size: const Size(64, 64), painter: LogoPainter()),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text[language]!['title']!,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.cyan,
              ),
            ),
            Text(
              text[language]!['subtitle']!,
              style: const TextStyle(fontSize: 12, color: Colors.cyanAccent),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildNetworkDiagram() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.cyan.shade500),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text[language]!['networkNodes']!,
                style: TextStyle(
                  color: Colors.cyan.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${text[language]!['mainframeStatus']}:',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 96,
                    child: LinearProgressIndicator(
                      value: mainframeCompromised / 100,
                      backgroundColor: Colors.grey.shade700,
                      color:
                          mainframeCompromised > 60
                              ? Colors.red.shade500
                              : mainframeCompromised > 30
                              ? Colors.yellow.shade500
                              : Colors.green.shade500,
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$mainframeCompromised%',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomPaint(
                painter: NetworkPainter(
                  networkNodes: networkNodes,
                  networkConnections: networkConnections,
                  playerPosition: playerPosition,
                  mousePosition: mousePosition,
                  collectibles: collectibles,
                  blockedNodes: blockedNodes,
                  disconnectedNodes: disconnectedNodes,
                  mainframeCompromised: mainframeCompromised,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgrammingInterface() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.cyan.shade500),
          ),
          child: Column(
            children: [
              Text(
                text[language]!['commandPool']!,
                style: TextStyle(
                  color: Colors.cyan.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
                itemCount: commandPool.length,
                itemBuilder: (context, index) {
                  final command = commandPool[index];
                  return Draggable<Command>(
                    data: command,
                    feedback: Material(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: command.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              command.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                            Text(
                              command.description,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: command.color,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            command.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                          Text(
                            command.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade500),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text[language]!['tracingProgram']!,
                    style: TextStyle(
                      color: Colors.green.shade400,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DragTarget<Command>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.green.shade700),
                    ),
                    child:
                        tracingProgram.isEmpty
                            ? Center(
                              child: Text(
                                'Drag commands here to build your trace program...',
                                style: TextStyle(
                                  color: Colors.green.shade600.withValues(
                                    alpha: 0.5,
                                  ),
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            )
                            : ListView.builder(
                              itemCount: tracingProgram.length,
                              itemBuilder: (context, index) {
                                final command = tracingProgram[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade800.withValues(
                                      alpha: 0.75,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${index + 1}. ${command.name}',
                                        style: TextStyle(
                                          color: Colors.green.shade400,
                                          fontFamily: 'monospace',
                                          fontSize: 12,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            tracingProgram.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.red.shade400,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                  );
                },
                onAccept: (command) {
                  setState(() {
                    tracingProgram = [...tracingProgram, command];
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed:
                        tracingProgram.isEmpty || isExecutingProgram
                            ? null
                            : executeTracingProgram,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    child: Text(
                      text[language]!['executeProgram']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        tracingProgram = [];
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                    ),
                    child: Text(
                      text[language]!['clearProgram']!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildStatsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.cyan.shade500),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 16,
                    color: Colors.yellow,
                  ),
                  const SizedBox(width: 8),
                  Text(text[language]!['coins']!),
                ],
              ),
              Text(
                '$cyberCoins',
                style: TextStyle(
                  color: Colors.yellow.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text[language]!['level']!),
              Text(
                '$currentLevel',
                style: TextStyle(
                  color: Colors.cyan.shade400,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (playerSkills.isNotEmpty) ...[
            Text(
              text[language]!['skills']!,
              style: TextStyle(
                color: Colors.cyan.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: playerSkills.length,
              itemBuilder: (context, index) {
                final skill = playerSkills[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(skill.icon),
                          const SizedBox(width: 8),
                          Text(
                            skill.name[language]!,
                            style: TextStyle(
                              color: Colors.cyan.shade300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill.concept[language]!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        skill.skill[language]!,
                        style: TextStyle(
                          color: Colors.green.shade400,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          if (mouseInventory.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Mouse Abilities',
              style: TextStyle(
                color: Colors.red.shade400,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children:
                  mouseInventory.map((ability) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade900.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        ability.replaceAll('_', ' ').toUpperCase(),
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 10,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildMenuScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildLogo(),
                const SizedBox(height: 32),
                Text(
                  text[language]!['instructions']!,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => setState(() => language = 'en'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            language == 'en'
                                ? const Color.fromARGB(255, 1, 22, 53)
                                : Colors.cyan.shade600,
                        backgroundColor:
                            language == 'en'
                                ? Colors.cyan.shade600
                                : Colors.grey.shade700,
                      ),
                      child: const Text('English'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () => setState(() => language = 'es'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            language == 'es'
                                ? Color.fromARGB(255, 1, 22, 53)
                                : Colors.cyan.shade600,
                        backgroundColor:
                            language == 'es'
                                ? Colors.cyan.shade600
                                : Colors.grey.shade700,
                      ),
                      child: const Text('Español'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => setState(() => gameState = 'playing'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color.fromARGB(255, 1, 22, 53),
                    backgroundColor: Colors.cyan.shade600,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.play_arrow),
                      const SizedBox(width: 8),
                      Text(
                        text[language]!['play']!,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyan.shade500),
                      ),
                      child: Column(
                        children: [
                          Text(
                            text[language]!['collectiblesTitle']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: collectibleTypes.length,
                              itemBuilder: (context, index) {
                                final item = collectibleTypes[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            item.icon,
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            item.name[language]!,
                                            style: TextStyle(
                                              color: Colors.cyan.shade300,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.concept[language]!,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.skill[language]!,
                                        style: TextStyle(
                                          color: Colors.green.shade400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyan.shade500),
                      ),
                      child: Column(
                        children: [
                          Text(
                            text[language]!['howToPlayTitle']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: text[language]!['howToPlay'].length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Text(
                                    text[language]!['howToPlay'][index],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text('Parent Mode'),
                                        content: Text(
                                          text[language]!['parentMode']!,
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.people),
                                const SizedBox(width: 8),
                                Text(text[language]!['parentMode']!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGameScreen() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildLogo(),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed:
                              () => setState(() {
                                gameState =
                                    gameState == 'playing'
                                        ? 'paused'
                                        : 'playing';
                              }),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color.fromARGB(255, 1, 22, 53),
                            backgroundColor: Colors.cyan.shade600,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                gameState == 'playing'
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                gameState == 'playing'
                                    ? text[language]!['pause']!
                                    : text[language]!['play']!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => initializeNetwork(currentLevel),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.replay),
                              const SizedBox(width: 8),
                              Text(text[language]!['reset']!),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => setState(() => gameState = 'menu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                          ),
                          child: const Text('Menu'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 900) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 2, child: buildNetworkDiagram()),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              children: [
                                buildProgrammingInterface(),
                                const SizedBox(height: 16),
                                buildStatsPanel(),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          buildNetworkDiagram(),
                          const SizedBox(height: 16),
                          buildProgrammingInterface(),
                          const SizedBox(height: 16),
                          buildStatsPanel(),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (gameState) {
      case 'menu':
        return buildMenuScreen();
      case 'playing':
      case 'paused':
        return buildGameScreen();
      case 'level-complete':
        return Stack(
          children: [
            buildGameScreen(),
            ModalBarrier(color: Colors.black.withValues(alpha: 0.75)),
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.cyan.shade500),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 64,
                      color: Colors.yellow,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      text[language]!['caught']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Level $currentLevel Complete!',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '+100 CyberCoins Bonus!',
                      style: TextStyle(
                        color: Colors.yellow.shade400,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentLevel++;
                              gameState = 'playing';
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Next Level'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => setState(() => gameState = 'menu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Main Menu'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case 'game-over':
        return Stack(
          children: [
            buildGameScreen(),
            ModalBarrier(color: Colors.black.withValues(alpha: 0.75)),
            Center(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade500),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.storage, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      text[language]!['escaped']!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'The cyber mouse reached the mainframe!',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Network security compromised at $mainframeCompromised%',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            initializeNetwork(currentLevel);
                            setState(() => gameState = 'playing');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Try Again'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => setState(() => gameState = 'menu'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade600,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Main Menu'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      default:
        return buildMenuScreen();
    }
  }
}

class NetworkPainter extends CustomPainter {
  final List<NetworkNode> networkNodes;
  final List<NetworkConnection> networkConnections;
  final Offset playerPosition;
  final Offset mousePosition;
  final List<Collectible> collectibles;
  final List<String> blockedNodes;
  final List<String> disconnectedNodes;
  final int mainframeCompromised;

  NetworkPainter({
    required this.networkNodes,
    required this.networkConnections,
    required this.playerPosition,
    required this.mousePosition,
    required this.collectibles,
    required this.blockedNodes,
    required this.disconnectedNodes,
    required this.mainframeCompromised,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw connections first (so they appear behind nodes)
    for (final conn in networkConnections) {
      final fromNode = networkNodes.firstWhere((n) => n.id == conn.from);
      final toNode = networkNodes.firstWhere((n) => n.id == conn.to);

      final isDisconnected =
          disconnectedNodes.contains(conn.from) ||
          disconnectedNodes.contains(conn.to);
      final isBlocked =
          blockedNodes.contains(conn.from) || blockedNodes.contains(conn.to);

      // Draw connection line
      final paint =
          Paint()
            ..color =
                isDisconnected
                    ? Colors.red.shade400
                    : isBlocked
                    ? Colors.yellow.shade400
                    : Colors.cyan.shade400
            ..strokeWidth =
                isDisconnected
                    ? 1
                    : isBlocked
                    ? 3
                    : 10
            ..style = PaintingStyle.stroke;

      if (isDisconnected) {
        paint.strokeCap = StrokeCap.round;
        final dashWidth = 5;
        final dashSpace = 5;
        double distance = sqrt(
          pow(toNode.x - fromNode.x, 2) + pow(toNode.y - fromNode.y, 2),
        );
        final path = Path();
        path.moveTo(fromNode.x.toDouble(), fromNode.y.toDouble());
        path.lineTo(toNode.x.toDouble(), toNode.y.toDouble());

        final dashPath = Path();
        double start = 0;
        while (start < distance) {
          dashPath.addPath(path, Offset.zero);
          start += dashWidth;
          dashPath.addPath(path, Offset(-start, 0));
          start += dashSpace;
        }
        canvas.drawPath(dashPath, paint);
      } else {
        canvas.drawLine(
          Offset(fromNode.x.toDouble(), fromNode.y.toDouble()),
          Offset(toNode.x.toDouble(), toNode.y.toDouble()),
          paint,
        );
      }
    }

    // Draw nodes
    for (final node in networkNodes) {
      final isPlayer =
          (playerPosition.dx - node.x).abs() < 20 &&
          (playerPosition.dy - node.y).abs() < 20;
      final isMouse =
          (mousePosition.dx - node.x).abs() < 20 &&
          (mousePosition.dy - node.y).abs() < 20;
      final isBlocked = blockedNodes.contains(node.id);
      final isDisconnected = disconnectedNodes.contains(node.id);
      final collectible = collectibles.firstWhere(
        (c) => c.nodeId == node.id && !c.collected,
        orElse: () => Collectible.empty(),
      );

      // Node background
      final nodePaint =
          Paint()
            ..color = _getNodeColor(
              node.type,
              node.type == 'mainframe',
              mainframeCompromised,
            )
            ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(node.x.toDouble(), node.y.toDouble()),
        40, // Larger node size
        nodePaint,
      );

      // Node border
      final borderPaint =
          Paint()
            ..color =
                isPlayer
                    ? Colors.cyan.shade400
                    : isMouse
                    ? Colors.red.shade400
                    : Colors.grey.shade700
            ..strokeWidth = isPlayer || isMouse ? 3 : 1
            ..style = PaintingStyle.stroke;

      canvas.drawCircle(
        Offset(node.x.toDouble(), node.y.toDouble()),
        40, // Larger node size
        borderPaint,
      );

      // Firewall shield overlay
      if (isBlocked) {
        final shieldPaint =
            Paint()
              ..color = Colors.yellow.shade400
              ..strokeWidth = 5
              ..style = PaintingStyle.stroke;

        final dashPath =
            Path()..addArc(
              Rect.fromCircle(
                center: Offset(node.x.toDouble(), node.y.toDouble()),
                radius: 24,
              ),
              0,
              2 * pi,
            );

        final dashPaint =
            Paint()
              ..color = Colors.yellow.shade400
              ..strokeWidth = 5
              ..style = PaintingStyle.stroke;
        //..pathEffect = PathEffect.dashPathEffect([3, 3], 0);

        canvas.drawPath(dashPath, dashPaint);
      }

      // Node label
      final textPainter = TextPainter(
        text: TextSpan(
          text: node.name,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          node.x.toDouble() - textPainter.width / 2,
          node.y.toDouble() - 35,
        ),
      );

      // Collectible
      if (collectible.id != null) {
        final collectiblePainter = TextPainter(
          text: TextSpan(
            text: collectible.icon,
            style: const TextStyle(fontSize: 24),
          ),
          textDirection: TextDirection.ltr,
        );
        collectiblePainter.layout();
        collectiblePainter.paint(
          canvas,
          Offset(node.x.toDouble() + 25, node.y.toDouble() - 15),
        );
      }

      // Player and Mouse
      if (isPlayer) {
        final playerPainter = TextPainter(
          text: const TextSpan(text: '🐱', style: TextStyle(fontSize: 24)),
          textDirection: TextDirection.ltr,
        );
        playerPainter.layout();
        playerPainter.paint(
          canvas,
          Offset(
            node.x.toDouble() - playerPainter.width / 2,
            node.y.toDouble() - playerPainter.height / 2 + 5,
          ),
        );
      }

      if (isMouse) {
        final mousePainter = TextPainter(
          text: const TextSpan(text: '🐭', style: TextStyle(fontSize: 24)),
          textDirection: TextDirection.ltr,
        );
        mousePainter.layout();
        mousePainter.paint(
          canvas,
          Offset(
            node.x.toDouble() - mousePainter.width / 2,
            node.y.toDouble() - mousePainter.height / 2 + 5,
          ),
        );
      }
    }
  }

  Color _getNodeColor(String nodeType, bool isMainframe, int compromised) {
    if (nodeType == 'mainframe') {
      return compromised > 0 ? Colors.red.shade400 : Colors.blue.shade400;
    }

    switch (nodeType) {
      case 'workstation':
        return Colors.blue.shade400;
      case 'smartphone':
        return Colors.green.shade400;
      case 'server':
        return Colors.purple.shade400;
      case 'router':
        return Colors.orange.shade400;
      case 'switch':
        return Colors.yellow.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.cyan
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFF1A1A1A),
    );

    // Main circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2 + 10), 30, paint);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2 + 10),
      30,
      borderPaint,
    );

    // Top ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2 - 15),
        width: 55,
        height: 8,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2 - 15),
        width: 55,
        height: 8,
      ),
      borderPaint,
    );

    // Top rectangle
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.175,
          size.width * 0.4,
          size.height * 0.15,
        ),
        const Radius.circular(15),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.3,
          size.height * 0.175,
          size.width * 0.4,
          size.height * 0.15,
        ),
        const Radius.circular(15),
      ),
      borderPaint,
    );

    // Line in rectangle
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.25, size.width * 0.4, 3),
      paint,
    );

    // Eyes
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4125, size.height * 0.52),
        width: 15,
        height: 9,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5875, size.height * 0.52),
        width: 15,
        height: 9,
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.4125, size.height * 0.52),
        width: 15,
        height: 9,
      ),
      borderPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5875, size.height * 0.52),
        width: 15,
        height: 9,
      ),
      borderPaint,
    );

    // Nose
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.505),
        width: 5,
        height: 6,
      ),
      paint,
    );

    // Mouth (triangle)
    final mouthPath =
        Path()
          ..moveTo(size.width / 2, size.height * 0.625)
          ..lineTo(size.width * 0.475, size.height * 0.675)
          ..lineTo(size.width * 0.525, size.height * 0.675)
          ..close();
    canvas.drawPath(mouthPath, paint);
    canvas.drawPath(mouthPath, borderPaint);

    // Whiskers
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.575),
      borderPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.65),
      Offset(size.width * 0.2, size.height * 0.65),
      borderPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.575),
      borderPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.65),
      Offset(size.width * 0.8, size.height * 0.65),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NetworkNode {
  final String id;
  final int x;
  final int y;
  final String type;
  final String name;

  NetworkNode({
    required this.id,
    required this.x,
    required this.y,
    required this.type,
    required this.name,
  });
}

class NetworkConnection {
  final String from;
  final String to;

  NetworkConnection({required this.from, required this.to});
}

class Collectible {
  final String? id;
  final Map<String, String> name;
  final String icon;
  final Map<String, String> concept;
  final Map<String, String> skill;
  final String? command;
  final int coins;
  final String mouseEffect;
  final int? x;
  final int? y;
  final String? nodeId;
  final bool collected;

  Collectible({
    this.id,
    required this.name,
    required this.icon,
    required this.concept,
    required this.skill,
    this.command,
    required this.coins,
    required this.mouseEffect,
    this.x,
    this.y,
    this.nodeId,
    this.collected = false,
  });

  factory Collectible.empty() => Collectible(
    id: null,
    name: {},
    icon: '',
    concept: {},
    skill: {},
    coins: 0,
    mouseEffect: '',
  );

  Collectible copyWith({
    String? id,
    Map<String, String>? name,
    String? icon,
    Map<String, String>? concept,
    Map<String, String>? skill,
    String? command,
    int? coins,
    String? mouseEffect,
    int? x,
    int? y,
    String? nodeId,
    bool? collected,
  }) {
    return Collectible(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      concept: concept ?? this.concept,
      skill: skill ?? this.skill,
      command: command ?? this.command,
      coins: coins ?? this.coins,
      mouseEffect: mouseEffect ?? this.mouseEffect,
      x: x ?? this.x,
      y: y ?? this.y,
      nodeId: nodeId ?? this.nodeId,
      collected: collected ?? this.collected,
    );
  }
}

class Command {
  final String id;
  final String name;
  final String description;
  final Color color;

  Command({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });
}

class PathNode {
  final NetworkNode node;
  final List<NetworkNode> path;

  PathNode({required this.node, required this.path});
}
