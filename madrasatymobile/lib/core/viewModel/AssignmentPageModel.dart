import 'package:madrasatymobile/core/Models/Assignment.dart';
import 'package:madrasatymobile/core/enums/ViewState.dart';
import 'package:madrasatymobile/core/services/AssignmentServices.dart';
import 'package:madrasatymobile/core/viewmodel/BaseModel.dart';
import 'package:madrasatymobile/locator.dart';

class AssignmentPageModel extends BaseModel {
  AssignmentServices _assignmentServices = locator<AssignmentServices>();

  List<Assignment> assignments = [];

  AssignmentPageModel() {
    print('Assignment Page Model Created');
  }

  Future<List<Assignment>> getAssignments() async {
    setState(ViewState.Busy);
    assignments = await _assignmentServices.getAssignments();
    setState(ViewState.Idle);
    return assignments;
  }

  Future<int> addAssignment(Assignment assignment) async {
    setState(ViewState.Busy);
    int response = await _assignmentServices.uploadAssignment(assignment);
    await Future.delayed(const Duration(seconds: 3), () {});
    setState(ViewState.Idle);
    return response;
  }

  onRefresh() async {
    await getAssignments();
  }

  @override
  void dispose() {
    assignments.clear();
    super.dispose();
    print('Assignment Page Model Disposed');
  }
}
