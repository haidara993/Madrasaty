// import 'package:flutter/material.dart';
// import 'package:madrasaty/UI/BaseView.dart';
// import 'package:madrasaty/UI/Utility/Resources.dart';
// import 'package:madrasaty/UI/Utility/constants.dart';
// import 'package:madrasaty/UI/widgets/BottomSheetChildrensWidget.dart';
// import 'package:madrasaty/UI/widgets/ChildrenGridViewCard.dart';
// import 'package:madrasaty/UI/widgets/TopBar.dart';
// import 'package:madrasaty/core/enums/ViewState.dart';
// import 'package:madrasaty/core/viewModel/ProfilePageModel.dart';

// class ChildrensPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BaseView<ProfilePageModel>(
//         onModelReady: (model) => model.getChildrens(),
//         builder: (context, model, child) {
//           return Scaffold(
//             appBar: TopBar(
//               buttonHeroTag: string.childrens,
//               child: kBackBtn,
//               onPressed: () {
//                 kbackBtn(context);
//               },
//               title: string.childrens,
//             ),
//             body: model.state == ViewState.Busy
//                 ? kBuzyPage(color: Theme.of(context).primaryColor)
//                 : model.childrens.length == 0
//                     ? Center(
//                         child: Text('No Child Added in database!',
//                             style: ktitleStyle.copyWith(fontSize: 20)),
//                       )
//                     : GridView.builder(
//                         physics: BouncingScrollPhysics(),
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 9 / 9,
//                           crossAxisSpacing: 0,
//                           mainAxisSpacing: 0,
//                         ),
//                         itemCount: model.childrens.length,
//                         itemBuilder: (context, index) {
//                           return Container(
//                             constraints:
//                                 BoxConstraints(maxHeight: 200, maxWidth: 200),
//                             child: ChildrenGridViewCard(
//                               user: model.childrens[index],
//                               onTap: () {
//                                 if (model.childrens[index].displayName != '')
//                                   showBottomSheet(
//                                     elevation: 10,
//                                     context: context,
//                                     builder: (context) =>
//                                         BottomSheetChildrensWidget(
//                                       user: model.childrens[index],
//                                     ),
//                                   );
//                               },
//                             ),
//                           );
//                         }),
//           );
//         });
//   }
// }
