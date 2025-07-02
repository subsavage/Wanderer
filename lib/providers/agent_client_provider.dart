// lib/providers/agent_client_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wanderer/agent/agent_client.dart';

final agentClientProvider = Provider<AgentClient>((ref) => AgentClient());
