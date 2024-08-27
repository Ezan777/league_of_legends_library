import 'package:league_of_legends_library/core/model/league_of_legends/rank.dart';
import 'package:league_of_legends_library/data/dto/participant_dto.dart';

class MatchDto {
  final String gameId;
  final QueueType queueType;
  final List<ParticipantDto> participants;

  const MatchDto(
      {required this.gameId,
      required this.queueType,
      required this.participants});
}
