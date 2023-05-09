/*****************************************************************************
 *   Ledger App Boilerplate.
 *   (c) 2020 Ledger SAS.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *****************************************************************************/

#ifdef HAVE_BAGL

#include "os.h"
#include "ux.h"
#include "glyphs.h"

#include "../globals.h"
#include "menu.h"

UX_STEP_NOCB(ux_menu_ready_step, pnn, {&C_boilerplate_logo, "Boilerplate", "is ready"});
UX_STEP_NOCB(ux_menu_version_step, bn, {"Version", APPVERSION});
UX_STEP_CB(ux_menu_about_step, pb, ui_menu_about(), {&C_icon_certificate, "About"});
UX_STEP_VALID(ux_menu_exit_step, pb, os_sched_exit(-1), {&C_icon_dashboard_x, "Quit"});
UX_STEP_NOCB(ux_display_string_step,
             bnnn_paging,
             {
                 .title = "boxing",
                 .text = "5EoXM0rjQ2tL8xRiCyflkKPpuA1YZb7cDsIw3hVqNnmBdUv9aGzW6FgH4TSgZ5DfdjKQLPY2VmxB7iRAcoNTHpr9X1W8OsbIa6e0tuEv",
             });

UX_STEP_NOCB(ux_display_string_step_1,
             bnnn_paging,
             {
                 .title = "The",
                 .text = "WkzTJpLbPdKj3qouI4O2Q0e8NtRi7GhvHcS1X9fU6xmsyVnYAF5ECwZarBglaKjRJYs6GNMPUHu9y1x8teQ7VnIb2ZvLcpWwXFmDz",
             });

UX_STEP_NOCB(ux_display_string_step_2,
             bnnn_paging,
             {
                 .title = "slow",
                 .text = "Zp98l0JvGKw1CuUVkA5hYtWOoXrQ2xePbRiSTyINBnfFqMEmDj47c3sa6LHdQ3WlT8SvJ9mRIcgBfzPbwyF0ux2UaNkY1E4Xe7H5",
             });

UX_STEP_NOCB(ux_display_string_step_3,
             bnnn_paging,
             {
                 .title = "onyx",
                 .text = "rN7V0Y6pUKO1bWgjxPEvXz5faJHewlAISimTu2DtkGy9scMqRLF8QC43BZnHOwVHvz80Th2NSjIg6xuE9XcUeAmdy7rkQL1C5Z",
             });

UX_STEP_NOCB(ux_display_string_step_4,
             bnnn_paging,
             {
                 .title = "goblin",
                 .text = "dW1NcG5LZzQis29kRf8YKIHhAM4q3EbmXoPvBaj0t7VxU6TSuJpOnwFyCrBgDgOsxwuEqbHJmX2PFvlNzypIRfSC6Va0YjT8a2I",
             });
UX_STEP_NOCB(ux_display_string_step_5,
             bnnn_paging,
             {
                 .title = "jumps",
                 .text = "xS5z2GjBvud8abwW4p1J3qkE9XtPhsrKl0nAfyIYFmLc7TeMgZONQiV6RCoUT9JXfL6xlN34sKbZRm1uV7nOHGQwYyhzPivkEa0",
             });
UX_STEP_NOCB(ux_display_string_step_6,
             bnnn_paging,
             {
                 .title = "over",
                 .text = "yWInkmvJdqAXTSgVOPHRN8QGzo9UE10b5hZufc7tLwF4jB6x2K3lsraCipMVtFRXNeKj3ZqOc7p64YUhWwP8iM2GALsg0yDbx1a",
             });
UX_STEP_NOCB(ux_display_string_step_7,
             bnnn_paging,
             {
                 .title = "the",
                 .text = "s9yXQmKbW1zrGn4DcPwL7VhOjJf8aT0xUZIeNv6pHlE5qgi3tuF2kRCAoBX8RlVxOz1KfJG3udWtewPApm4sZ6iaNknY2qcQb0",
             });
UX_STEP_NOCB(ux_display_string_step_8,
             bnnn_paging,
             {
                 .title = "lazy",
                 .text = "x6yX9lB1vRzKjZ0FwHJcUoMTGia8umgWAbE7VQnsPf2IpLh3eN5DStO4CqYkE7h6mWdXfz9ksUyvr34L2Gc1j5wQat0JPZgN8u",
             });
UX_STEP_NOCB(ux_display_string_step_9,
             bnnn_paging,
             {
                 .title = "dwarf",
                 .text = "9P~xG(TDOXvj9P+40rW=f@C$c|t3-^ll6VAYLLxM(!;Q)eeD#>6qQc,I2M\"/}TN#E>cOlC+>L/KvpfNlGO3_/=UJ294HU5vGNzQnmu2GoSGt>@a%%$o^3!Yh&c`BWbR5=M,ZRwCZhv/!ReM^&r??XbZY^/",
             });

// "Pack my box with five dozen liquor jugs."
// "The five boxing wizards jump quickly."
// "Sphinx of black quartz, judge my vow."
// "My ex pub quiz crowd gave joyful thanks."
// "Jaded zombies acted quaintly but kept driving their oxen forward."
// "The quick onyx goblin jumps over the lazy dwarf."
// "The jay, pig, fox, zebra and my wolves quack."
// "Waltz, nymph, for quick jigs vex Bud."

// FLOW for the main menu:
UX_FLOW(ux_menu_main_flow,
        &ux_menu_ready_step,
        &ux_menu_version_step,
        &ux_menu_about_step,
        &ux_display_string_step,
        &ux_display_string_step_1,
        &ux_display_string_step_2,
        &ux_display_string_step_3,
        &ux_display_string_step_4,
        &ux_display_string_step_5,
        &ux_display_string_step_6,
        &ux_display_string_step_7,
        &ux_display_string_step_8,
        &ux_display_string_step_9,
        &ux_menu_exit_step);

void ui_menu_main() {
    if (G_ux.stack_count == 0) {
        ux_stack_push();
    }

    ux_flow_init(0, ux_menu_main_flow, NULL);
}

UX_STEP_NOCB(ux_menu_info_step, bn, {"Boilerplate App", "(c) 2020 Ledger"});
UX_STEP_CB(ux_menu_back_step, pb, ui_menu_main(), {&C_icon_back, "Back"});

// FLOW for the about submenu:
// #1 screen: app info
// #2 screen: back button to main menu
UX_FLOW(ux_menu_about_flow, &ux_menu_info_step, &ux_menu_back_step, FLOW_LOOP);

void ui_menu_about() {
    ux_flow_init(0, ux_menu_about_flow, NULL);
}

#endif
