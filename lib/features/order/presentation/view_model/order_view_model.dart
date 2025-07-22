import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:servzz/features/order/domain/use_case/create_order_usecase.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderViewModel extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase createOrderUseCase;

  OrderViewModel({required this.createOrderUseCase}) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      await createOrderUseCase(event.order);
      emit(OrderSuccess());
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }
}
