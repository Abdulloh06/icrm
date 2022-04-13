import 'package:icrm/core/models/attachment_model.dart';
import 'package:icrm/core/service/api/get_attachment.dart';
import 'package:icrm/core/util/get_it.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_event.dart';
import 'package:icrm/features/presentation/blocs/attachment_bloc/attachment_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  AttachmentBloc(AttachmentState initialState) : super(initialState) {
    on<AttachmentShowEvent>((event, emit) async {
      emit(AttachmentLoadingState());

      try {
        List<AttachmentModel> documents =
            await getIt.get<GetAttachment>().showContentAttachment(
                  content_type: event.content_type,
                  id: event.content_id,
                );

        emit(AttachmentShowState(documents: documents));
      } catch (error) {
        print(error);
        emit(AttachmentErrorState(error: error.toString()));
      }
    });

    on<AttachmentAddEvent>((event, emit) async {
      emit(AttachmentLoadingState());

      try {
        bool result = await getIt.get<GetAttachment>().addAttachment(
          content_type: event.content_type,
          content_id: event.content_id,
          file: event.file,
        );

        if (result) {
          List<AttachmentModel> documents =
              await getIt.get<GetAttachment>().showContentAttachment(
                    content_type: event.content_type,
                    id: event.content_id,
                  );

          emit(AttachmentShowState(documents: documents));
        } else {
          emit(AttachmentErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        print(error);

        emit(AttachmentErrorState(error: error.toString()));
      }
    });

    on<AttachmentDeleteEvent>((event, emit) async {
      emit(AttachmentLoadingState());
      try {
        bool result =
            await getIt.get<GetAttachment>().deleteAttachment(id: event.id);

        if (result) {
          List<AttachmentModel> documents =
              await getIt.get<GetAttachment>().showContentAttachment(
                    content_type: event.content_type,
                    id: event.content_id,
                  );

          emit(AttachmentShowState(documents: documents));
        } else {
          emit(AttachmentErrorState(error: 'something_went_wrong'));
        }
      } catch (error) {
        print(error);

        emit(AttachmentErrorState(error: error.toString()));
      }
    });
  }
}
