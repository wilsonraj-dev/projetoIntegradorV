import 'package:flutter/material.dart';
import 'package:projeto_pi_flutter/common/custom_drawer/custom_icon_button.dart';
import 'package:projeto_pi_flutter/model/item_size.dart';
import 'package:projeto_pi_flutter/model/product.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {

  const SizesForm(this.product);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: List.from(product.sizes),
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ItemSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value.map((size){
                return EditItemSize(
                  size: size,
                  onRemove: () {
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}